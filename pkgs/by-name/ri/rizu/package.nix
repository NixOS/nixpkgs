{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
  love,
  luajit,
  imagemagick,
  ffmpeg,
  zlib,
  libbass,
  libbass_fx,
  libbassmix,
  libbassopus,
  discord-rpc,
  fftw,
  libiconvReal,
  rtmidi,
  sqlite,
  p7zip,
  sse2neon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rizu";
  version = "0-unstable-2026-01-05";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "semyon422";
    repo = "rizu";
    # to get the commit hash of the latest version:
    # download https://dl.rizu.su/rizu.zip and extract, and then extract version.lua file from rizu.love
    rev = "6b22a63f21203c790e549c90b0f8acb2f9aabbd0";
    fetchSubmodules = true;
    postCheckout = "git -C $out show -s --format=%ct HEAD > $out/.gitdate";
    hash = "sha256-xpOOv4FwZD5rJ/2ZzLDPOxKxUYC6DkW1RCaLnYYj7VA=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    imagemagick
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  patches = [
    # change all writing to the userdata dir in the installation dir into the love default app data dir
    ./writable-userdata.patch

    # do not change LD_LIBRARY_PATH, LUA_PATH, and LUA_CPATH
    ./keep-search-path.patch
  ];

  postPatch = ''
    substituteInPlace version.lua \
      --replace-fail 'commit = ""' 'commit = "${finalAttrs.src.rev}"' \
      --replace-fail 'date = ""' "date = \"$(date -u -d @$(cat .gitdate))\""

    cp ${finalAttrs.passthru.urls} sphere/persistence/ConfigModel/urls.lua

    substituteInPlace sphere/persistence/ConfigModel/settings.lua \
      --replace-fail 'autoUpdate = true' 'autoUpdate = false'

    # because of write-userdata.patch, use this replacement to avoid an extra layer of subdir in the app data dir
    find -type f -name '*.lua' -exec sed -i 's|"userdata/|"|g' {} +
  '';

  installPhase = ''
    runHook preInstall

    phome=$out/share/rizu
    mkdir -p $phome

    find -type f \( -name '*.c' -o -name '*.lua' -o -name '*.sql' \) -exec cp -a --parents {} $phome \;
    cp -a -r userdata resources $phome

    makeWrapper ${lib.getExe (love.override { inherit luajit; })} $out/bin/rizu \
      --add-flags $phome \
      --add-flags --fused \
      --suffix LUA_CPATH ";" "${
        # https://github.com/semyon422/rizu/blob/110f01ef82bc3f137433bab98fac505ee8fd9dca/install
        with luajit.pkgs;
        lib.concatMapStringsSep ";" luajit.pkgs.getLuaCPath [
          luasocket
          luaossl
          luasec
          bcrypt
          md5
          utf8
          lsqlite3
          etlua
          luacov
          luacov-reporter-lcov
          nginx-lua-prometheus
          enet
        ]
      }" \
      --suffix ${
        if stdenv.hostPlatform.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH"
      } : "${
        # https://github.com/semyon422/rizu/tree/110f01ef82bc3f137433bab98fac505ee8fd9dca/bin/linux64
        lib.makeLibraryPath (
          [
            zlib
            libbass
            libbass_fx
            libbassmix
            libbassopus
            discord-rpc
            fftw
            libiconvReal
            rtmidi
            sqlite
            finalAttrs.passthru.minacalc
            finalAttrs.passthru.lovemidi
            finalAttrs.passthru.lib7z
          ]
          ++ lib.optional (!stdenv.hostPlatform.isDarwin) finalAttrs.passthru.video
        )
      }" \
      --run '
        # the canonical result of https://www.love2d.org/wiki/love.filesystem.getSaveDirectory
        rizu_userdata="''${XDG_DATA_HOME:-$HOME/.local/share}/rizu"
        if [ ! -d "$rizu_userdata" ]; then
          mkdir -p "$(dirname "$rizu_userdata")"
          cp -r '$phome/userdata' "$rizu_userdata"
          chmod -R a=r,u+w,a+X "$rizu_userdata"
        fi
        # otherwise causes skin loading error because our patches lead dofile to read relative to pwd
        cd $rizu_userdata
      '

    mkdir -p $out/share/icons/hicolor/512x512/apps
    ln -s $phome/resources/logo.png $out/share/icons/hicolor/512x512/apps/rizu.png
    for size in 16 32 48 64 128 256; do
      dir=$out/share/icons/hicolor/''${size}x$size/apps
      mkdir -p "$dir"
      magick $phome/resources/logo.png -resize ''${size}x$size "$dir/rizu.png"
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rizu";
      desktopName = "Rizu";
      comment = finalAttrs.meta.description;
      exec = "rizu %U";
      icon = "rizu";
      categories = [
        "Game"
        "AudioVideo"
      ];
    })
  ];

  passthru = {
    lib7z = stdenv.mkDerivation {
      pname = "rizu-lib7z";
      version = finalAttrs.version;

      src = fetchurl {
        url = "https://www.7-zip.org/a/lzma2600.7z";
        hash = "sha256-a30MjtGmcRLVM35FMuzcuf0uq4sfa7VBmfm2pie1Bsw=";
        meta.license = lib.licenses.publicDomain;
      };

      nativeBuildInputs = [ p7zip ];
      unpackCmd = "7z x $curSrc C && cp ${finalAttrs.src}/aqua/7z.c C/7z.c";

      buildPhase = ''
        runHook preBuild

        # https://github.com/semyon422/aqua/blob/20b8a7d9f582b7b7a5da22646676303df561320b/7z.c#L11-L15
        $CC ${lib.optionalString stdenv.hostPlatform.isLinux "-D_GNU_SOURCE "}-shared -fPIC \
          -o lib7z.${if stdenv.hostPlatform.isDarwin then "dylib" else "so"} 7z.c

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        lib=lib7z.${if stdenv.hostPlatform.isDarwin then "dylib" else "so"}
        install -Dm644 $lib $out/lib/$lib

        runHook postInstall
      '';

      meta = {
        platforms = lib.platforms.unix;
        inherit (finalAttrs.meta) maintainers license;
      };
    };

    video = stdenv.mkDerivation {
      pname = "rizu-video";
      version = finalAttrs.version;

      src = "${finalAttrs.src}/aqua/video.c";
      unpackCmd = "mkdir source && cp $curSrc source/video.c";

      # ffmpeg has removed avcodec_close
      postPatch = "substituteInPlace video.c --replace-fail 'avcodec_close(' 'avcodec_free_context(&'";

      buildInputs = [
        ffmpeg
        luajit
      ];

      buildPhase = ''
        runHook preBuild

        # https://github.com/semyon422/aqua/blob/20b8a7d9f582b7b7a5da22646676303df561320b/video.c#L3
        $CC -fPIC -shared -o video.so video.c \
          -lavformat -lavcodec -lswresample -lswscale -lavutil -lm

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib
        cp video.so $out/lib

        runHook postInstall
      '';

      meta = {
        platforms = lib.platforms.linux;
        inherit (finalAttrs.meta) maintainers license;
      };
    };

    minacalc = stdenv.mkDerivation {
      pname = "minacalc";
      version = "0-unstable-2025-07-06";

      src = fetchFromGitHub {
        owner = "Nimue-lua";
        repo = "minacalc-standalone";
        rev = "ffff66ace74fc77c779a0f1f0cca62740dd90a60";
        hash = "sha256-/G2pPrX2qnSUd7DqE47ln2E9lEjYKV5rImjapCrUuno=";
      };

      postPatch = ''
        substituteInPlace build-macos build-linux --replace-fail gcc $CC
      '';

      # https://github.com/Nimue-lua/minacalc-standalone/blob/ffff66ace74fc77c779a0f1f0cca62740dd90a60/MinaCalc/PatternModHelpers.h#L6-L11
      buildInputs = lib.optional stdenv.hostPlatform.isAarch64 sse2neon;

      buildPhase = ''
        runHook preBuild

        bash ${if stdenv.hostPlatform.isDarwin then "build-macos" else "build-linux"}

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        lib=libminacalc${stdenv.hostPlatform.extensions.sharedLibrary}
        install -Dm644 $lib $out/lib/$lib

        runHook postInstall
      '';

      meta = {
        description = "Standalone version of MinaCalc along with a C API for easy access and bindings";
        homepage = "https://github.com/Nimue-lua/minacalc-standalone";
        # https://github.com/kangalio/minacalc-standalone/blob/38687d1fc43994652e9808eae4e9d63b167bc27b/LICENSE.txt
        license = lib.licenses.mit;
        inherit (finalAttrs.meta) maintainers;
        platforms = lib.platforms.unix;
      };
    };

    lovemidi = stdenv.mkDerivation {
      pname = "lovemidi";
      version = "0-unstable-2024-02-26";

      src = fetchFromGitHub {
        owner = "SiENcE";
        repo = "lovemidi";
        rev = "9c4e2a17c7abc3a8eaf068d24c85cc4ab87f30cf";
        hash = "sha256-Cw1j7aDY8PA/HFv6xYI4XJFSDr1qVYkHU6o56JUZ+k4=";
      };

      postPatch = ''
        substituteInPlace src/luamidi.cpp --replace-fail '#include "RtMidi.h"' '#include <rtmidi/RtMidi.h>'
      '';

      buildInputs = [
        rtmidi
        luajit
      ];

      buildPhase = ''
        runHook preBuild

        c++ -DluaL_reg=luaL_Reg -shared -fPIC src/luamidi.cpp -lluajit-5.1 -lrtmidi \
          -o luamidi.${if stdenv.hostPlatform.isDarwin then "0.1.dylib" else "so.0.1"}

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        lib=luamidi${stdenv.hostPlatform.extensions.sharedLibrary}
        lib_v=luamidi.${if stdenv.hostPlatform.isDarwin then "0.1.dylib" else "so.0.1"}
        install -Dm644 $lib_v $out/lib/$lib_v
        ln -s $out/lib/$lib_v $out/lib/$lib

        runHook postInstall
      '';

      meta = {
        description = "Give LÖVE a midi i/o interface; based on luamidi and rtmidi";
        homepage = "https://github.com/jdeeny/lovemidi";
        license = lib.licenses.free; # missing license file: https://github.com/SiENcE/lovemidi/issues/7
        platforms = lib.platforms.unix;
        inherit (finalAttrs.meta) maintainers;
      };
    };

    urls = ./urls.lua;

    updateScript = ./update.sh;
  };

  meta = {
    description = "Open-source rhythm game";
    homepage = "https://rizu.su";
    downloadPage = "https://rizu.su/download";
    license = with lib.licenses; [
      gpl3Only
      # the repo contains some 3rd party code with different licenses
      mit
      free # some 3rd party codes have broken upstream link and missing license files
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = love.meta.platforms;
    mainProgram = "rizu";
  };
})
