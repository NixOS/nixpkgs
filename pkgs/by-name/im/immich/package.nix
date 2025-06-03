{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
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
  sourcesJSON ? ./sources.json,
}:
let
  buildNpmPackage' = buildNpmPackage.override { inherit nodejs; };
  sources = lib.importJSON sourcesJSON;
  inherit (sources) version;

  esbuild_0_23 = buildPackages.esbuild.override {
    buildGoModule =
      args:
      buildPackages.buildGoModule (
        args
        // rec {
          version = "0.23.0";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            tag = "v${version}";
            hash = "sha256-AH4Y5ELPicAdJZY5CBf2byOxTzOyQFRh4XoqRUQiAQw=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };

  esbuild_0_25 = buildPackages.esbuild.override {
    buildGoModule =
      args:
      buildPackages.buildGoModule (
        args
        // rec {
          version = "0.25.2";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            tag = "v${version}";
            hash = "sha256-aDxheDMeQYqCT9XO3In6RbmzmXVchn+bjgf3nL3VE4I=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };

  # Immich server does not actually need esbuild, but react-email and vite do.
  # As esbuild doesn't support passing multiple binaries, we use a custom
  # "shim", that picks the right version depending on the working directory.
  # The correct version can be looked up in package-lock.json
  # TODO: There are numerous other env vars this *could* be based on.
  esbuildShim = buildPackages.writeShellScriptBin "esbuild" ''
    echo "nixpkgs: esbuild shim for '$PWD'" >&2
    case "$PWD" in
      "/build/server/node_modules/esbuild")
        exec ${lib.getExe esbuild_0_23} "$@"
      ;;
      "/build/server/node_modules/vite/node_modules/esbuild")
        exec ${lib.getExe esbuild_0_25} "$@"
        exit 0
      ;;
    esac
    echo "nixpkgs: Couldn't resolve esbuild version for '$PWD'" >&2
    exit 1
  '';

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
      inherit (sources.components.geonames) timestamp;
      date =
        "${lib.substring 0 4 timestamp}-${lib.substring 4 2 timestamp}-${lib.substring 6 2 timestamp}T"
        + "${lib.substring 8 2 timestamp}:${lib.substring 10 2 timestamp}:${lib.substring 12 2 timestamp}Z";
    in
    runCommand "immich-geodata"
      {
        outputHash = sources.components.geonames.hash;
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
        url="https://web.archive.org/web/${timestamp}/http://download.geonames.org/export/dump"
        curl -Lo ./cities500.zip "$url/cities500.zip"
        curl -Lo $out/admin1CodesASCII.txt "$url/admin1CodesASCII.txt"
        curl -Lo $out/admin2Codes.txt "$url/admin2Codes.txt"
        curl -Lo $out/ne_10m_admin_0_countries.geojson \
          https://github.com/nvkelso/natural-earth-vector/raw/ca96624a56bd078437bca8184e78163e5039ad19/geojson/ne_10m_admin_0_countries.geojson

        unzip ./cities500.zip -d $out/
        echo "${date}" > $out/geodata-date.txt
      '';

  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "immich";
    tag = "v${version}";
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

    # prePatch is needed because npmConfigHook is a postPatch
    prePatch = ''
      # some part of the build wants to use un-prefixed binaries. let them.
      mkdir -p $TMP/bin
      ln -s "$(type -p ${stdenv.cc.targetPrefix}pkg-config)" $TMP/bin/pkg-config || true
      ln -s "$(type -p ${stdenv.cc.targetPrefix}c++filt)" $TMP/bin/c++filt || true
      ln -s "$(type -p ${stdenv.cc.targetPrefix}readelf)" $TMP/bin/readelf || true
      export PATH="$TMP/bin:$PATH"
    '';

    preBuild = ''
      rm node_modules/@immich/sdk
      ln -s ${openapi} node_modules/@immich/sdk
    '';

    env.npm_config_build_from_source = "true";

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      # https://github.com/Automattic/node-canvas/blob/master/Readme.md#compiling
      cairo
      giflib
      libjpeg
      libpng
      librsvg
      pango
      pixman
    ];

    installPhase = ''
      runHook preInstall

      cp -r build $out

      runHook postInstall
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

  # prePatch is needed because npmConfigHook is a postPatch
  prePatch = ''
    # pg_dumpall fails without database root access
    # see https://github.com/immich-app/immich/issues/13971
    substituteInPlace src/services/backup.service.ts \
      --replace-fail '`/usr/lib/postgresql/''${databaseMajorVersion}/bin/pg_dumpall`' '`pg_dump`'

    # some part of the build wants to use un-prefixed binaries. let them.
    mkdir -p $TMP/bin
    ln -s "$(type -p ${stdenv.cc.targetPrefix}pkg-config)" $TMP/bin/pkg-config || true
    ln -s "$(type -p ${stdenv.cc.targetPrefix}c++filt)" $TMP/bin/c++filt || true
    ln -s "$(type -p ${stdenv.cc.targetPrefix}readelf)" $TMP/bin/readelf || true
    export PATH="$TMP/bin:$PATH"
  '';

  nativeBuildInputs = [
    pkg-config
    python3
    makeWrapper
    glib
    node-gyp # for building node_modules/sharp from source
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

  env.SHARP_FORCE_GLOBAL_LIBVIPS = 1;
  env.ESBUILD_BINARY_PATH = lib.getExe esbuildShim;

  preBuild = ''
    # If exiftool-vendored.pl isn't found, exiftool is searched for on the PATH
    rm -r node_modules/exiftool-vendored.*
  '';

  installPhase = ''
    runHook preInstall

    npm config delete cache
    npm prune --omit=dev

    # remove build artifacts that bloat the closure
    rm -r node_modules/**/{*.target.mk,binding.Makefile,config.gypi,Makefile,Release/.deps}

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
