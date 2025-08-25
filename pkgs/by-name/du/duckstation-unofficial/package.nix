{
  lib,
  llvmPackages,
  stdenvNoCC,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  extra-cmake-modules,
  wayland-scanner,
  makeBinaryWrapper,
  qt6,
  sdl3,
  zstd,
  libwebp,
  zlib,
  libpng,
  libjpeg,
  freetype,
  plutosvg,
  cpuinfo,
  discord-rpc,
  soundtouch,
  cubeb,
  libzip,
  curl,
  libX11,
  wayland,
  shaderc,
  spirv-cross,
  udev,
  libbacktrace,
  ffmpeg-headless,
  fetchurl,
  zip,
  unzip,
}:

let
  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Fast PlayStation 1 emulator for x86-64/AArch32/AArch64/RV64";
    longDescription = ''
      # DISCLAIMER
      This is an **unofficial** package, do not report any issues to
      duckstation developers. Instead, please report them to
      <https://github.com/NixOS/nixpkgs> or use the officially
      supported platform build at <https://duckstation.org> or other
      upstream-approved distribution mechanism not listed here. We
      (nixpkgs) do not endorse or condone any action taken on your own
      accord in regards to this package.
    '';
    homepage = "https://duckstation.org";
    license = lib.licenses.cc-by-nc-nd-40;
    maintainers = with lib.maintainers; [ normalcea ];
  };

  pkgSources = lib.importJSON ./sources.json;

  linuxDrv = llvmPackages.stdenv.mkDerivation (finalAttrs: {
    pname = "duckstation-unofficial";
    version = pkgSources.duckstation.version;

    src = fetchFromGitHub {
      owner = "stenzek";
      repo = "duckstation";
      tag = "v${finalAttrs.version}";
      hash = pkgSources.duckstation.hash_linux;
    };

    patches = [
      # un-vendor cubeb
      ./0001-remove-cubeb-vendor.patch
      # Fix NEON intrinsics usage
      ./0002-fix-NEON-intrinsics.patch
    ];

    vendorDiscordRPC = discord-rpc.overrideAttrs (oldAttrs: {
      pname = "discord-rpc-duckstation";
      version = "3.4.0-unstable-${pkgSources.discord_rpc.date}";
      src = fetchFromGitHub {
        owner = "stenzek";
        repo = "discord-rpc";
        rev = pkgSources.discord_rpc.rev;
        hash = pkgSources.discord_rpc.hash;
      };
      patches = oldAttrs.patches or [ ];
    });

    vendorSoundtouch = soundtouch.overrideAttrs (oldAttrs: {
      pname = "soundtouch-duckstation";
      version = "2.3.3-unstable-${pkgSources.soundtouch.date}";

      src = fetchFromGitHub {
        owner = "stenzek";
        repo = "soundtouch";
        rev = pkgSources.soundtouch.rev;
        hash = pkgSources.soundtouch.hash;
      };

      nativeBuildInputs = [ cmake ];

      preConfigure = null;
    });

    vendorShaderc = shaderc.overrideAttrs (oldAttrs: {
      pname = "shaderc-duckstation";
      version = "2025.2-unstable-${pkgSources.shaderc.date}";
      src = fetchFromGitHub {
        owner = "stenzek";
        repo = "shaderc";
        rev = pkgSources.shaderc.rev;
        hash = pkgSources.shaderc.hash;
      };

      patches = (oldAttrs.patches or [ ]);
      cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
        (lib.cmakeBool "SHADERC_SKIP_EXAMPLES" true)
        (lib.cmakeBool "SHADERC_SKIP_TESTS" true)
      ];
      outputs = [
        "out"
        "lib"
        "dev"
      ];
      postFixup = null;
    });

    vendorChtdb = stdenvNoCC.mkDerivation {
      pname = "chtdb-duckstation";
      version = "0-unstable-${pkgSources.chtdb.date}";

      src = fetchFromGitHub {
        owner = "duckstation";
        repo = "chtdb";
        rev = pkgSources.chtdb.rev;
        hash = pkgSources.chtdb.hash;
      };

      nativeBuildInputs = [
        zip
      ];

      buildPhase = ''
        runHook preBuild

        pushd cheats
        zip -r cheats.zip *.cht
        popd
        pushd patches
        zip -r patches.zip *.cht
        popd

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        install -Dm644 cheats/cheats.zip -t $out/lib/duckstation
        install -Dm644 patches/patches.zip -t $out/lib/duckstation

        install -Dm644 LICENSE -t $out/share/doc/duckstation
        install -Dm644 README.md -t $out/share/doc/duckstation

        runHook postInstall
      '';

      meta = {
        description = "Collection of cheats and patches for PSX games";
        longDescription = ''
          Collection of cheats and patches for PSX games, primarily intended for
          use with the DuckStation emulator, but can also be used by other
          emulators that support GameShark codes.

          Patches show in the UI in a separate section to cheats, and are
          intended for modifications to the game that do not provide any
          "advantage" to the player, including:

          - Improving performance.
          - Fixing game-breaking bugs.
          - Unlocking the frame rate (e.g. "60 FPS patches").
          - Widescreen rendering where the built-in widescreen rendering rendering is insufficient.
        '';
        license = lib.licenses.mit;
        inherit (meta) maintainers;
        platforms = lib.platforms.all;
      };
    };

    preConfigure = ''
      cp ${finalAttrs.vendorChtdb}/lib/duckstation/cheats.zip data/resources
      cp ${finalAttrs.vendorChtdb}/lib/duckstation/patches.zip data/resources
    '';

    nativeBuildInputs = [
      cmake
      pkg-config
      ninja
      extra-cmake-modules
      wayland-scanner
      makeBinaryWrapper
      qt6.wrapQtAppsHook
      qt6.qttools
    ];

    buildInputs = [
      sdl3
      zstd
      libwebp
      zlib
      libpng
      libjpeg
      freetype
      plutosvg
      cubeb
      cpuinfo
      libzip
      curl
      libX11
      wayland
      spirv-cross
      qt6.qtbase
      udev
      libbacktrace
      ffmpeg-headless
    ]
    ++ [
      finalAttrs.vendorDiscordRPC
      finalAttrs.vendorShaderc
      finalAttrs.vendorSoundtouch
    ];

    cmakeFlags = [
      (lib.cmakeBool "ALLOW_INSTALL" true)
      (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/lib/duckstation")
    ];

    qtWrapperArgs = [
      "--prefix LD_LIBRARY_PATH : ${(lib.makeLibraryPath [ ffmpeg-headless ])}"
    ];

    postInstall = ''
      makeWrapper $out/lib/duckstation/duckstation-qt $out/bin/duckstation-qt

      mkdir -p $out/share/applications
      ln -s $out/lib/duckstation/resources/org.duckstation.DuckStation.desktop \
            $out/share/applications

      mkdir -p $out/share/icons/hicolor/512x512/apps
      ln -s $out/lib/duckstation/resources/org.duckstation.DuckStation.png \
            $out/share/icons/hicolor/512x512/apps

      pushd ..
      install -Dm644 LICENSE -t $out/share/doc/duckstation
      install -Dm644 README.* -t $out/share/doc/duckstation
      install -Dm644 CONTRIBUTORS.md -t $out/share/doc/duckstation
      popd
    '';

    inherit passthru;

    meta = {
      inherit (meta)
        description
        longDescription
        homepage
        license
        maintainers
        ;
      mainProgram = "duckstation-qt";
      platforms = lib.platforms.linux;
    };
  });

  darwinDrv = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "duckstation-unofficial";
    version = pkgSources.duckstation.version;

    src = fetchurl {
      url = "https://github.com/stenzek/duckstation/releases/download/v${finalAttrs.version}/duckstation-mac-release.zip";
      hash = pkgSources.duckstation.hash_darwin;
    };

    nativeBuildInputs = [ unzip ];

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r DuckStation.app $out/Applications/DuckStation.app

      runHook postInstall
    '';

    inherit passthru;

    meta = {
      inherit (meta)
        description
        longDescription
        homepage
        license
        maintainers
        ;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = lib.platforms.darwin;
    };
  });
in
if stdenvNoCC.hostPlatform.isLinux then
  linuxDrv
else if stdenvNoCC.hostPlatform.isDarwin then
  darwinDrv
else
  throw "No supported build."
