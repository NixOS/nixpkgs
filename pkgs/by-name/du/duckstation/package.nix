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
  soundtouch,
  rapidjson,
  libzip,
  curl,
  libX11,
  wayland,
  shaderc,
  spirv-cross,
  udev,
  libbacktrace,
  ffmpeg_8-headless,
  cubeb,
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
      DISCLAIMER: This is an **unofficial** package, do not report any
      issues to duckstation developers. Instead, please report them to
      <https://github.com/NixOS/nixpkgs> or use the officially
      supported platform build at <https://duckstation.org> or other
      upstream-approved distribution mechanism not listed here.
    '';
    homepage = "https://duckstation.org";
    license = lib.licenses.cc-by-nc-nd-40;
    maintainers = with lib.maintainers; [
      normalcea
      matteopacini
    ];
  };

  pkgSources = lib.importJSON ./sources.json;

  linuxDrv = llvmPackages.stdenv.mkDerivation (finalAttrs: {
    pname = "duckstation";
    version = "0.1-10130";

    src = fetchFromGitHub {
      owner = "stenzek";
      repo = "duckstation";
      tag = "v${finalAttrs.version}";
      deepClone = true;
      hash = "sha256-K7vqTv8m5JMAPvZuc2nyc1yh8he8RYx0OlqqxdPwNXg=";

      postFetch = ''
        cd $out
        mkdir -p .nixpkgs-auxfiles/
        git rev-parse HEAD > .nixpkgs-auxfiles/git_hash
        git rev-parse --abbrev-ref HEAD | tr -d '\r\n' > .nixpkgs-auxfiles/git_branch
        git describe | tr -d '\r\n' > .nixpkgs-auxfiles/git_tag
        git log -1 --date=iso8601-strict --format=%cd > .nixpkgs-auxfiles/git_date
        rm -rf .git
      '';
    };

    patches = [
      ./cubeb-remove-vendor.patch
      ./git-version-info.patch
    ];

    postPatch =
      # Fixes compilation error with nixpkgs libapng
      ''
        substituteInPlace src/util/animated_image.cpp \
          --replace-fail "png_write_frame_head(png_ptr, info_ptr," \
                         "png_write_frame_head(png_ptr, info_ptr, 0,"
      ''
      # Fills in git-info obtained in the `postFetch` step for version
      # information in the UI
      + ''
        gitHash=$(cat .nixpkgs-auxfiles/git_hash) \
        gitBranch=$(cat .nixpkgs-auxfiles/git_branch) \
        gitTag=$(cat .nixpkgs-auxfiles/git_tag) \
        gitDate=$(cat .nixpkgs-auxfiles/git_date) \
        substituteAllInPlace src/scmversion/gen_scmversion.sh
      '';

    vendorDiscordRPC = llvmPackages.stdenv.mkDerivation {
      pname = "discord-rpc-duckstation";
      inherit (finalAttrs) version;
      src = fetchFromGitHub {
        owner = "stenzek";
        repo = "discord-rpc";
        inherit (pkgSources.discord_rpc) rev hash;
      };
      nativeBuildInputs = [ cmake ];
      buildInputs = [ rapidjson ];
      meta = {
        license = lib.licenses.mit;
        platforms = lib.platforms.linux;
      };
    };

    vendorShaderc = shaderc.overrideAttrs (oldAttrs: {
      pname = "shaderc-duckstation";
      inherit (finalAttrs) version;
      src = fetchFromGitHub {
        owner = "stenzek";
        repo = "shaderc";
        inherit (pkgSources.shaderc) rev hash;
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

    soundtouch = llvmPackages.stdenv.mkDerivation {
      inherit (soundtouch)
        pname
        version
        src
        meta
        ;
      nativeBuildInputs = [ cmake ];
      postPatch = ''
        substituteInPlace CMakeLists.txt \
          --replace-fail "\''${prefix}/''${CMAKE_INSTALL_LIBDIR}" \
                         "''${CMAKE_INSTALL_FULL_LIBDIR}"
      '';

      cmakeFlags = [
        (lib.cmakeBool "SOUNDTOUCH_DLL" true)
      ];
    };

    chtdb = stdenvNoCC.mkDerivation {
      pname = "chtdb-duckstation";
      version = "0-unstable-${pkgSources.chtdb.date}";

      src = fetchFromGitHub {
        owner = "duckstation";
        repo = "chtdb";
        inherit (pkgSources.chtdb) rev hash;
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
          - Widescreen rendering where the built-in widescreen
            rendering rendering is insufficient.
        '';
        license = lib.licenses.mit;
        inherit (meta) maintainers;
        platforms = lib.platforms.all;
      };
    };

    preConfigure = ''
      cp ${finalAttrs.chtdb}/lib/duckstation/cheats.zip data/resources
      cp ${finalAttrs.chtdb}/lib/duckstation/patches.zip data/resources
    '';

    nativeBuildInputs = [
      cmake
      pkg-config
      ninja
      extra-cmake-modules
      wayland-scanner
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
      cpuinfo
      libzip
      curl
      libX11
      wayland
      spirv-cross
      qt6.qtbase
      udev
      libbacktrace
      ffmpeg_8-headless
      cubeb
    ]
    ++ [
      finalAttrs.vendorDiscordRPC
      finalAttrs.vendorShaderc
      finalAttrs.soundtouch
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{lib,bin,share/{applications,icons/hicolor/512x512/apps}}
      cp -r bin $out/lib/duckstation
      ln -s $out/lib/duckstation/duckstation-qt $out/bin/duckstation-qt
      ln -s $out/lib/duckstation/resources/org.duckstation.DuckStation.desktop \
            $out/share/applications
      ln -s $out/lib/duckstation/resources/org.duckstation.DuckStation.png \
            $out/share/icons/hicolor/512x512/apps

      pushd ..
      install -Dm644 LICENSE -t $out/share/doc/duckstation
      install -Dm644 README.* -t $out/share/doc/duckstation
      install -Dm644 CONTRIBUTORS.md -t $out/share/doc/duckstation
      popd

      runHook postInstall
    '';

    qtWrapperArgs = [
      "--prefix LD_LIBRARY_PATH : ${
        (lib.makeLibraryPath [
          ffmpeg_8-headless
          finalAttrs.vendorShaderc
        ])
      }"
    ];

    inherit passthru;

    meta = meta // {
      mainProgram = "duckstation-qt";
      platforms = lib.platforms.linux;
    };
  });

  darwinDrv = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "duckstation";
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

    meta = meta // {
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
  throw "duckstation is not supported on ${stdenvNoCC.hostPlatform.system}."
