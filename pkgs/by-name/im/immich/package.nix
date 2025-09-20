{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  python3,
  nodejs,
  node-gyp,
  runCommand,
  nixosTests,
  immich-machine-learning,
  # build-time deps
  pkg-config,
  makeWrapper,
  curl,
  cacert,
  unzip,
  # runtime deps
  cairo,
  exiftool,
  giflib,
  jellyfin-ffmpeg, # Immich depends on the jellyfin customizations, see https://github.com/NixOS/nixpkgs/issues/351943
  imagemagick,
  libjpeg,
  libpng,
  libraw,
  libheif,
  librsvg,
  pango,
  perl,
  pixman,
  vips,
  buildPackages,
}:
let
  pnpm = pnpm_10;
  version = "1.142.1";

  esbuild' = buildPackages.esbuild.override {
    buildGoModule =
      args:
      buildPackages.buildGoModule (
        args
        // rec {
          version = "0.25.5";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            tag = "v${version}";
            hash = "sha256-jemGZkWmN1x2+ZzJ5cLp3MoXO0oDKjtZTmZS9Be/TDw=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };

  buildLock = {
    sources =
      builtins.map
        (p: {
          name = p.pname;
          inherit (p) version;
          inherit (p.src) rev;
        })
        [
          imagemagick
          libheif
          libraw
        ];

    packages = [ ];
  };

  # The geodata website is not versioned, so we use the internet archive
  geodata =
    let
      timestamps= {
        "cities500.zip"= "20250830185200";
        "admin1CodesASCII.txt"= "20250828115302";
        "admin2Codes.txt"= "20250828115302";
      };
      urls = builtins.mapAttrs (f: t: "https://web.archive.org/web/${t}/"
        + "http://download.geonames.org/export/dump/${f}") timestamps; # Convert timestamps to URLs
      date = (f: "${f 0 + f 2}-${f 4}-${f 6}T${f 8}:${f 10}:${f 12}Z")
        (x: lib.substring x 2 timestamps."cities500.zip"); # ISO-8601 date format
    in
    runCommand "immich-geodata"
      {
        outputHash = "sha256-zcRHKkrb56WsjVoep7Bxm21UkWzqgo9Mx8f5FQD/W2s=";
        outputHashMode = "recursive";
        nativeBuildInputs = [
          cacert
          curl
          unzip
        ];

        meta.license = lib.licenses.cc-by-40;
      }
      ''
        mkdir $out
        curl -Lo ./cities500.zip "${urls."cities500.zip"}"
        curl -Lo $out/admin1CodesASCII.txt "${urls."admin1CodesASCII.txt"}"
        curl -Lo $out/admin2Codes.txt "${urls."admin2Codes.txt"}"
        curl -Lo $out/ne_10m_admin_0_countries.geojson \
          https://github.com/nvkelso/natural-earth-vector/raw/ca96624a56bd078437bca8184e78163e5039ad19/geojson/ne_10m_admin_0_countries.geojson

        unzip ./cities500.zip -d $out/
        echo "${date}" > $out/geodata-date.txt
      '';

  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "immich";
    tag = "v${version}";
    hash = "sha256-u538GWupnkH2K81Uk9yEuHc3pAeVexnJOnhWo7gElL0=";
  };

  pnpmDeps = pnpm.fetchDeps {
    pname = "immich";
    inherit version src;
    fetcherVersion = 2;
    hash = "sha256-aYG5SpFZxhbz32YAdP39RYwn2GV+mFWhddd4IFuPuz8=";
  };

  web = stdenv.mkDerivation {
    pname = "immich-web";
    inherit version src pnpmDeps;

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpm.configHook
    ];

    buildPhase = ''
      runHook preBuild

      pnpm --filter @immich/sdk build
      pnpm --filter immich-web build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cd web
      cp -r build $out

      runHook postInstall
    '';
  };
in
stdenv.mkDerivation {
  pname = "immich";
  inherit version src pnpmDeps;

  postPatch = ''
    # pg_dumpall fails without database root access
    # see https://github.com/immich-app/immich/issues/13971
    substituteInPlace server/src/services/backup.service.ts \
      --replace-fail '`/usr/lib/postgresql/''${databaseMajorVersion}/bin/pg_dumpall`' '`pg_dump`'
  '';

  nativeBuildInputs = [
    nodejs
    pkg-config
    pnpm_10
    pnpm_10.configHook
    python3
    makeWrapper
    node-gyp # for building node_modules/sharp from source
  ];

  buildInputs = [
    jellyfin-ffmpeg
    imagemagick
    libraw
    libheif
    # https://github.com/Automattic/node-canvas/blob/master/Readme.md#compiling
    cairo
    giflib
    libjpeg
    libpng
    librsvg
    pango
    pixman
    # Required for sharp
    vips
  ];

  env.SHARP_FORCE_GLOBAL_LIBVIPS = 1;
  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';
  # fix for node-gyp, see https://github.com/nodejs/node-gyp/issues/1191#issuecomment-301243919
  env.npm_config_nodedir = nodejs;

  buildPhase = ''
    runHook preBuild

    # If exiftool-vendored.pl isn't found, exiftool is searched for on the PATH
    rm node_modules/.pnpm/node_modules/exiftool-vendored.pl

    pnpm --filter immich build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local -r packageOut="$out/lib/node_modules/immich"

    # install node_modules and built files in $out
    # upstream uses pnpm deploy to build their docker images
    pnpm --filter immich deploy --prod --no-optional "$packageOut"

    # remove build artifacts that bloat the closure
    find "$packageOut/node_modules" \( \
      -name config.gypi \
      -o -name .deps \
      -o -name '*Makefile' \
      -o -name '*.target.mk' \
    \) -exec rm -r {} +

    mkdir -p "$packageOut/build"
    ln -s '${web}' "$packageOut/build/www"
    ln -s '${geodata}' "$packageOut/build/geodata"

    echo '${builtins.toJSON buildLock}' > "$packageOut/build/build-lock.json"

    makeWrapper '${lib.getExe nodejs}' "$out/bin/admin-cli" \
      --add-flags "$packageOut/dist/main" \
      --add-flags cli
    makeWrapper '${lib.getExe nodejs}' "$out/bin/server" \
      --add-flags "$packageOut/dist/main" \
      --chdir "$packageOut" \
      --set IMMICH_BUILD_DATA "$packageOut/build" \
      --set NODE_ENV production \
      --suffix PATH : '${
        lib.makeBinPath [
          exiftool
          jellyfin-ffmpeg
          perl # exiftool-vendored checks for Perl even if exiftool comes from $PATH
        ]
      }'

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) immich immich-vectorchord-migration;
    };

    machine-learning = immich-machine-learning;

    inherit
      src
      web
      geodata
      pnpm
      ;
  };

  meta = {
    changelog = "https://github.com/immich-app/immich/releases/tag/${src.tag}";
    description = "Self-hosted photo and video backup solution";
    homepage = "https://immich.app/";
    license = with lib.licenses; [
      agpl3Only
      cc-by-40 # geonames
    ];
    maintainers = with lib.maintainers; [
      dotlambda
      jvanbruegge
      Scrumplex
      titaniumtown
    ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    mainProgram = "server";
  };
}
