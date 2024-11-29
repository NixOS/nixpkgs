{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch2,
  python3,
  nodejs,
  node-gyp,
  runCommand,
  nixosTests,
  immich-machine-learning,
  # build-time deps
  glib,
  pkg-config,
  makeWrapper,
  curl,
  cacert,
  unzip,
  # runtime deps
  exiftool,
  jellyfin-ffmpeg, # Immich depends on the jellyfin customizations, see https://github.com/NixOS/nixpkgs/issues/351943
  imagemagick,
  libraw,
  libheif,
  perl,
  vips,
}:
let
  buildNpmPackage' = buildNpmPackage.override { inherit nodejs; };
  sources = lib.importJSON ./sources.json;
  inherit (sources) version;

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
    runCommand "immich-geodata"
      {
        outputHash = "sha256-imqSfzXaEMNo9T9tZr80sr/89n19kiFc8qwidFzRUaY=";
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
        url="https://web.archive.org/web/20240724153050/http://download.geonames.org/export/dump"
        curl -Lo ./cities500.zip "$url/cities500.zip"
        curl -Lo $out/admin1CodesASCII.txt "$url/admin1CodesASCII.txt"
        curl -Lo $out/admin2Codes.txt "$url/admin2Codes.txt"
        curl -Lo $out/ne_10m_admin_0_countries.geojson \
          https://raw.githubusercontent.com/nvkelso/natural-earth-vector/ca96624a56bd078437bca8184e78163e5039ad19/geojson/ne_10m_admin_0_countries.geojson

        unzip ./cities500.zip -d $out/
        echo "2024-07-24T15:30:50Z" > $out/geodata-date.txt
      '';

  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "immich";
    rev = "v${version}";
    inherit (sources) hash;
  };

  openapi = buildNpmPackage' {
    pname = "immich-openapi-sdk";
    inherit version;
    src = "${src}/open-api/typescript-sdk";
    inherit (sources.components."open-api/typescript-sdk") npmDepsHash;

    installPhase = ''
      runHook preInstall

      npm config delete cache
      npm prune --omit=dev --omit=optional

      mkdir -p $out
      mv package.json package-lock.json node_modules build $out/

      runHook postInstall
    '';
  };

  web = buildNpmPackage' {
    pname = "immich-web";
    inherit version src;
    sourceRoot = "${src.name}/web";
    inherit (sources.components.web) npmDepsHash;

    preBuild = ''
      rm node_modules/@immich/sdk
      ln -s ${openapi} node_modules/@immich/sdk
      # Rollup does not find the dependency otherwise
      ln -s node_modules/@immich/sdk/node_modules/@oazapfts node_modules/
    '';

    installPhase = ''
      runHook preInstall

      cp -r build $out

      runHook postInstall
    '';
  };

  node-addon-api = stdenvNoCC.mkDerivation rec {
    pname = "node-addon-api";
    version = "8.0.0";
    src = fetchFromGitHub {
      owner = "nodejs";
      repo = "node-addon-api";
      rev = "v${version}";
      hash = "sha256-k3v8lK7uaEJvcaj1sucTjFZ6+i5A6w/0Uj9rYlPhjCE=";
    };
    installPhase = ''
      mkdir $out
      cp -r *.c *.h *.gyp *.gypi index.js package-support.json package.json tools $out/
    '';
  };

  vips' = vips.overrideAttrs (prev: {
    mesonFlags = prev.mesonFlags ++ [ "-Dtiff=disabled" ];
  });
in
buildNpmPackage' {
  pname = "immich";
  inherit version;
  src = "${src}/server";
  inherit (sources.components.server) npmDepsHash;

  postPatch = ''
    # pg_dumpall fails without database root access
    # see https://github.com/immich-app/immich/issues/13971
    substituteInPlace src/services/backup.service.ts \
      --replace-fail '`/usr/lib/postgresql/''${databaseMajorVersion}/bin/pg_dumpall`' '`pg_dump`'
  '';

  nativeBuildInputs = [
    pkg-config
    python3
    makeWrapper
    glib
    node-gyp
  ];

  buildInputs = [
    jellyfin-ffmpeg
    imagemagick
    libraw
    libheif
    vips' # Required for sharp
  ];

  # Required because vips tries to write to the cache dir
  makeCacheWritable = true;

  preBuild = ''
    pushd node_modules/sharp

    mkdir node_modules
    ln -s ${node-addon-api} node_modules/node-addon-api

    ${lib.getExe nodejs} install/check

    rm -r node_modules

    popd
    rm -r node_modules/@img/sharp*

    # If exiftool-vendored.pl isn't found, exiftool is searched for on the PATH
    rm -r node_modules/exiftool-vendored.*
  '';

  installPhase = ''
    runHook preInstall

    npm config delete cache
    npm prune --omit=dev

    mkdir -p $out/build
    mv package.json package-lock.json node_modules dist resources $out/
    ln -s ${web} $out/build/www
    ln -s ${geodata} $out/build/geodata

    echo '${builtins.toJSON buildLock}' > $out/build/build-lock.json

    makeWrapper ${lib.getExe nodejs} $out/bin/admin-cli --add-flags $out/dist/main --add-flags cli
    makeWrapper ${lib.getExe nodejs} $out/bin/server --add-flags $out/dist/main --chdir $out \
      --set IMMICH_BUILD_DATA $out/build --set NODE_ENV production \
      --suffix PATH : "${
        lib.makeBinPath [
          exiftool
          jellyfin-ffmpeg
          perl # exiftool-vendored checks for Perl even if exiftool comes from $PATH
        ]
      }"

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) immich;
    };

    machine-learning = immich-machine-learning;

    inherit
      src
      sources
      web
      geodata
      ;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Self-hosted photo and video backup solution";
    homepage = "https://immich.app/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      dotlambda
      jvanbruegge
      Scrumplex
      titaniumtown
    ];
    platforms = lib.platforms.linux;
    mainProgram = "server";
  };
}
