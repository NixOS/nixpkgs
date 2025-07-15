{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  makeWrapper,
  premake5,
  writeShellApplication,
  runCommandLocal,
  symlinkJoin,
  writeText,
  imagemagick,
  bzip2,
  curl,
  envsubst,
  flac,
  fmt,
  freetype,
  irrlicht,
  libevent,
  libgit2,
  libGL,
  libGLU,
  libjpeg,
  libpng,
  libvorbis,
  libX11,
  libxkbcommon,
  libXxf86vm,
  mono,
  nlohmann_json,
  openal,
  SDL2,
  sqlite,
  wayland,
  egl-wayland,
  zenity,
  covers_url ? "https://pics.projectignis.org:2096/pics/cover/{}.jpg",
  fields_url ? "https://pics.projectignis.org:2096/pics/field/{}.png",
  # While ygoprodeck has higher quality images:
  # 1. automated downloads for sims via their API are discouraged by the owner
  # 2. images for prerelease cards are unavailable on their service
  pics_url ? "https://pics.projectignis.org:2096/pics/{}.jpg",
}:
let
  archLabel =
    {
      "x86_64-linux" = "x64";
      "aarch64-linux" = "arm64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "${stdenv.hostPlatform.system} is an unsupported arch label for edopro");

  maintainers = with lib.maintainers; [
    OPNA2608
    redhawk
  ];

  deps = import ./deps.nix;

  edopro-src = fetchFromGitHub {
    owner = "edo9300";
    repo = "edopro";
    rev = deps.edopro-rev;
    fetchSubmodules = true;
    hash = deps.edopro-hash;
  };
in
let
  assets = fetchzip {
    url = "https://github.com/ProjectIgnis/edopro-assets/releases/download/${deps.edopro-version}/ProjectIgnis-EDOPro-${deps.edopro-version}-linux.tar.gz";
    hash = deps.assets-hash;
  };

  irrlicht-edopro = stdenv.mkDerivation {
    pname = "irrlicht-edopro";
    version = deps.irrlicht-version;

    src = fetchFromGitHub {
      owner = "edo9300";
      repo = "irrlicht1-8-4";
      rev = deps.irrlicht-rev;
      hash = deps.irrlicht-hash;
    };

    buildInputs = [
      libGLU
      libX11
      libxkbcommon
      libXxf86vm
      wayland
    ];

    enableParallelBuilding = true;
    buildFlags = [ "NDEBUG=1" ];
    makeFlags = [
      "-C"
      "source/Irrlicht"
    ];

    installPhase = ''
      runHook preInstall

      install -Dm644 -t $out/lib lib/Linux/libIrrlicht.a
      cp -r include $out/include

      runHook postInstall
    '';

    meta = {
      inherit (irrlicht.meta) description platforms;
      homepage = "https://github.com/edo9300/irrlicht1-8-4";
      license = lib.licenses.agpl3Plus;
      inherit maintainers;
    };
  };

  ocgcore =
    let
      # Refer to CORENAME EPRO_TEXT in <edopro>/gframe/dllinterface.cpp for this
      ocgcoreName = lib.strings.concatStrings [
        (lib.optionalString (!stdenv.hostPlatform.isWindows) "lib")
        "ocgcore"
        (
          if stdenv.hostPlatform.isiOS then
            "-ios"
          else if stdenv.hostPlatform.isAndroid then
            (
              if stdenv.hostPlatform.isx86_64 then
                "x64"
              else if stdenv.hostPlatform.isx86_32 then
                "x86"
              else if stdenv.hostPlatform.isAarch64 then
                "v8"
              else if stdenv.hostPlatform.isAarch32 then
                "v7"
              else
                throw "Don't know what platform suffix edopro expects for ocgcore on: ${stdenv.hostPlatform.system}"
            )
          else
            lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ".aarch64"
        )
        stdenv.hostPlatform.extensions.sharedLibrary
      ];
    in
    stdenv.mkDerivation {
      pname = "ocgcore-edopro";
      version = deps.edopro-version;

      src = edopro-src;
      sourceRoot = "${edopro-src.name}/ocgcore";

      nativeBuildInputs = [
        premake5
      ];

      enableParallelBuilding = true;

      buildFlags = [
        "verbose=true"
        "config=release"
        "ocgcoreshared"
      ];

      makeFlags = [
        "-C"
        "build"
      ];

      # To make sure linking errors are discovered at build time, not when edopro runs into them during loading
      env.NIX_LDFLAGS = "--unresolved-symbols=report-all";

      installPhase = ''
        runHook preInstall

        install -Dm644 bin/release/*ocgcore*${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/${ocgcoreName}

        runHook postInstall
      '';

      meta = {
        description = "YGOPro script engine";
        homepage = "https://github.com/edo9300/ygopro-core";
        license = lib.licenses.agpl3Plus;
        inherit maintainers;
        platforms = lib.platforms.unix;
      };
    };

  edopro = stdenv.mkDerivation {
    pname = "edopro";
    version = deps.edopro-version;

    src = edopro-src;

    nativeBuildInputs = [
      makeWrapper
      premake5
    ];

    buildInputs = [
      bzip2
      curl
      flac
      fmt
      freetype
      irrlicht-edopro
      libevent
      libgit2
      libjpeg
      libpng
      libvorbis
      nlohmann_json
      openal
      SDL2
      sqlite
    ];

    # nixpkgs' gcc stack currently appears to not support LTO
    # Override where bundled ocgcore get looked up in, so we can supply ours
    # (can't use --prebuilt-core or let it build a core on its own without making core updates impossible)
    postPatch = ''
      substituteInPlace premake5.lua \
        --replace-fail 'flags "LinkTimeOptimization"' 'removeflags "LinkTimeOptimization"'

      substituteInPlace gframe/game.cpp \
        --replace-fail 'ocgcore = LoadOCGcore(Utils::GetWorkingDirectory())' 'ocgcore = LoadOCGcore("${lib.getLib ocgcore}/lib/")'

      touch ocgcore/premake5.lua
    '';

    preBuild = ''
      premake5 gmake2 \
        --architecture=${archLabel} \
        --covers=\"${covers_url}\" \
        --fields=\"${fields_url}\" \
        --pics=\"${pics_url}\" \
        --no-core \
        --sound=sfml
    '';

    enableParallelBuilding = true;
    env = {
      # remove after release 40.1.4+
      # https://discord.com/channels/170601678658076672/792223685112889344/1286043823293599785
      CXXFLAGS = "-include cstdint";
      LDFLAGS = "-I ${irrlicht-edopro}/include -L ${irrlicht-edopro}/bin";
    };
    buildFlags = [
      "verbose=true"
      "config=release_${archLabel}"
      "ygoprodll"
    ];
    makeFlags = [
      "-C"
      "build"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp bin/${archLabel}/release/ygoprodll $out/bin
      wrapProgram $out/bin/ygoprodll \
        --prefix PATH : ${lib.makeBinPath [ mono ]} \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libGL
            libX11
            libxkbcommon
            libXxf86vm
            sqlite
            wayland
            egl-wayland
          ]
        }

      runHook postInstall
    '';

    meta = {
      description = "Bleeding-edge automatic duel simulator, a fork of the YGOPro client";
      homepage = "https://projectignis.github.io";
      changelog = "https://github.com/edo9300/edopro/releases";
      license = lib.licenses.agpl3Plus;
      mainProgram = "ygoprodll";
      # This is likely a very easy app to port if you're interested.
      # We just have no way to test on other platforms.
      platforms = [
        "x86_64-linux"
        # Currently offline mode does not work, the problem is that the core is updated whenever it is needed.
        # So in our method we would have to update the client if it's statically linked as well.
        # It is possible but we have decided against it for now.  In theory if we added more logic to the update script it could work.
        "aarch64-linux"
      ];
      inherit maintainers;
    };
  };

  edopro-script =
    let
      assetsToCopy = lib.concatStringsSep "," [
        # Needed if we download files from ProjectIgnis' website or any https-only website.
        "cacert.pem"
        "config"
        "deck"
        "COPYING.txt"
        "expansions"
        "lflists"
        "notices"
        "puzzles"
        "fonts"
        "script"
        "skin"
        "sound"
        "textures"
        "WindBot"
      ];
      wrapperZenityMessageTemplate = writeText "edopro-wrapper-multiple-versions-message.txt.in" ''
        Nixpkgs' EDOPro wrapper has found more than 1 directory in: ''${EDOPRO_BASE_DIR}

        We expected the only directory to be: ''${EDOPRO_DIR}

        There may have been an update, requiring you to migrate any files you care about from an older version.

        Examples include:

        - decks/*
        - config/system.conf - which has your client's settings
        - any custom things you may have installed into: fonts, skins, script, sound, ...
        - anything you wish to preserve from: replay, screenshots

        Once you have copied over everything important to ''${EDOPRO_DIR}, delete the old version's path.
      '';
    in
    writeShellApplication {
      name = "edopro";
      runtimeInputs = [
        envsubst
        zenity
      ];
      text = ''
        export EDOPRO_VERSION="${deps.edopro-version}"
        export EDOPRO_BASE_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/edopro"
        export EDOPRO_DIR="''${EDOPRO_BASE_DIR}/''${EDOPRO_VERSION}"

        # If versioned directory doesn't exist yet, make it & copy over assets
        if [ ! -d "$EDOPRO_DIR" ]; then
            mkdir -p "$EDOPRO_DIR"
            cp -r --no-preserve=all ${assets}/{${assetsToCopy}} "$EDOPRO_DIR"
            chmod -R go-rwx "$EDOPRO_DIR"

            rm "$EDOPRO_DIR"/config/io.github.edo9300.EDOPro.desktop.in
        fi

        # Different versions provide different assets. Some are necessary for the game to run properly (configs for
        # where to get incremental updates from, online servers, card scripting, certificates for communication etc),
        # and some are optional nice-haves (example decks). It's also possible to override assets with custom skins.
        #
        # Don't try to manage all of this across versions, just inform the user that they may need to migrate their
        # files if it looks like there are multiple versions.

        edoproTopDirs="$(find "$EDOPRO_BASE_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)"
        if [ "$edoproTopDirs" -ne 1 ]; then
          zenity \
            --info \
            --title='[NIX] Multiple asset copies found' \
            --text="$(envsubst < ${wrapperZenityMessageTemplate})" \
            --ok-label='Continue to EDOPro'
        fi

        exec ${lib.getExe edopro} -C "$EDOPRO_DIR" "$@"
      '';
    };

  edopro-desktop = runCommandLocal "io.github.edo9300.EDOPro.desktop" { } ''
    mkdir -p $out/share/applications

    sed ${assets}/config/io.github.edo9300.EDOPro.desktop.in \
      -e '/Path=/d' \
      -e 's/Exec=.*/Exec=edopro/' \
      -e 's/Icon=.*/Icon=edopro/' \
      -e 's/StartupWMClass=.*/StartupWMClass=edopro/' \
      >$out/share/applications/io.github.edo9300.EDOPro.desktop
  '';
in
symlinkJoin {
  name = "edopro-application-${deps.edopro-version}";
  version = deps.edopro-version;
  paths = [
    edopro-script
    edopro-desktop
  ];

  postBuild = ''
    for size in 16 32 48 64 128 256 512 1024; do
      res="$size"x"$size"
      mkdir -p $out/share/icons/hicolor/"$res"/apps/
      ${imagemagick}/bin/magick \
          ${assets}/textures/AppIcon.png \
          -resize "$res" \
          $out/share/icons/hicolor/"$res"/apps/edopro.png
    done
  '';

  passthru.updateScript = ./update.py;

  meta = {
    inherit (edopro.meta)
      description
      homepage
      changelog
      license
      platforms
      maintainers
      ;
    # To differentiate it from the original YGOPro
    mainProgram = "edopro";
  };
}
