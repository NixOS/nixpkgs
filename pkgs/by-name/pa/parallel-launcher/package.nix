{
  lib,
  stdenv,
  fetchFromGitLab,
  replaceVars,
  pkg-config,
  qt5,
  SDL2,
  discord-rpc,
  libgcrypt,
  sqlite,
  p7zip,
  findutils,
  xdg-utils,
  coreutils,
  dosfstools,
  udisks2,
  polkit,
  wrapRetroArch,
  libretro,
  retroarch-assets,
  # Allow overrides for RetroArch cores and declarative settings
  parallel-n64-core ? null,
  mupen64plus-core ? null,
  extraRetroArchSettings ? { },
}:
let
  # Converts a version string like x.y.z to vx.y-z
  reformatVersion = v: "v${lib.versions.majorMinor v}-${lib.versions.patch v}";

  # Converts a version string like x.y.z to x, y, z
  reformatVersion' = lib.replaceStrings [ "." ] [ ", " ];

  firstNonNull = lib.lists.findFirst (x: x != null) (throw "Failed to find non-null value");

  parallel-n64 = firstNonNull [
    parallel-n64-core
    (libretro.parallel-n64.overrideAttrs (
      final: prev: {
        pname = "${prev.pname}-next";
        version = "2.23.6";

        src = fetchFromGitLab {
          owner = "parallel-launcher";
          repo = "parallel-n64";
          tag = reformatVersion final.version;
          hash = "sha256-2j5mkYBMk1UcqEJYleARTDW7t3l0yxvJ0AbLiLml67Y=";
        };

        installPhase =
          let
            suffix = stdenv.hostPlatform.extensions.sharedLibrary;
          in
          ''
            runHook preInstall

            install -Dm644 parallel_n64_libretro${suffix} $out/lib/retroarch/cores/parallel_n64_next_libretro${suffix}

            runHook postInstall
          '';

        nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [
          pkg-config
        ];

        makeFlags = (prev.makeFlags or [ ]) ++ [
          "HAVE_THR_AL=1"
          "SYSTEM_LIBPNG=1"
          "SYSTEM_ZLIB=1"
        ];
      }
    ))
  ];

  mupen64plus = firstNonNull [
    mupen64plus-core
    libretro.mupen64plus
  ];

  retroArchAssetsPath = "${retroarch-assets}/share/retroarch/assets";
in
stdenv.mkDerivation (
  finalAttrs:
  let
    retroarch' = wrapRetroArch {
      cores = [
        parallel-n64
        mupen64plus
      ];

      # These settings take precedence over those supplied by user config files
      settings = {
        # Override the wrapper's libretro_info_path because that path doesn't
        # have any information about Parallel Launcher's parallel-n64 core fork.
        # Upstream provides this information in their own *.info files in $src/data.
        # Save states with the parallel-n64 core will not work without this.
        libretro_info_path = "${finalAttrs.src}/data";
        assets_directory = retroArchAssetsPath;
      } // extraRetroArchSettings;
    };
  in
  {
    pname = "parallel-launcher";
    version = "7.12.0"; # Check for parallel-n64 updates when updating, too (see above)

    src = fetchFromGitLab {
      owner = "parallel-launcher";
      repo = "parallel-launcher";
      tag = reformatVersion finalAttrs.version;
      hash = "sha256-LBjjmhlz9pZhh0rdq0nvmGdXIZNB9TRZ42pxYlqGf1M=";
    };

    patches = [
      # Fix FHS path assumptions
      (replaceVars ./fix-paths.patch {
        inherit retroArchAssetsPath;
        retroArchCoresPath = "${retroarch'}/lib/retroarch/cores";
        retroArchExePath = lib.getExe retroarch';
      })
      # Bypass update checks and hardcode internal version checks to ours
      (replaceVars ./fix-version-checks.patch {
        retroArchVersion = reformatVersion' (lib.getVersion retroarch');
        parallelCoreVersion = reformatVersion' (lib.getVersion parallel-n64);
        mupenCoreVersion = mupen64plus.src.rev;
      })
    ];

    nativeBuildInputs = [
      qt5.wrapQtAppsHook
      qt5.qttools
      qt5.qmake
    ];

    buildInputs =
      [
        SDL2
        discord-rpc
        libgcrypt
        sqlite
        p7zip
        findutils
        xdg-utils
        coreutils
        dosfstools
        qt5.qtbase
        qt5.qtsvg
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        polkit
        udisks2
      ];

    # Our patches result in unused params.
    # Ignoring the warning is easier to maintain than more invasive patching.
    env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-parameter";

    preConfigure = ''
      lrelease app.pro
    '';

    installPhase = ''
      runHook preInstall

      # Taken from pkg/arch/PKGBUILD
      install -D parallel-launcher -t $out/bin
      install -D ca.parallel_launcher.ParallelLauncher.desktop -t $out/share/applications
      install -D ca.parallel_launcher.ParallelLauncher.metainfo.xml -t $out/share/metainfo
      install -D data/appicon.svg $out/share/icons/hicolor/scalable/apps/ca.parallel_launcher.ParallelLauncher.svg
      install -D bps-mime.xml parallel-launcher-{lsjs,sdl-relay} -t $out/share/parallel-launcher
      install -D lang/*.qm -t $out/share/parallel-launcher/translations

      runHook postInstall
    '';

    meta = {
      description = "Modern N64 Emulator";
      longDescription = ''
        Parallel Launcher is an emulator launcher that aims to make playing N64 games,
        both retail and homebrew, as simple and as accessible as possible. Parallel
        Launcher uses the RetroArch emulator, but replaces its confusing menus and
        controller setup with a much simpler user interface. It also features optional
        integration with romhacking.com.
      '';
      homepage = "https://parallel-launcher.ca";
      changelog = "https://gitlab.com/parallel-launcher/parallel-launcher/-/releases/${finalAttrs.src.tag}";
      # Theoretically, platforms should be the intersection of what upstream supports,
      # what nixpkgs RetroArch supports, and what the RetroArch cores support
      platforms = [ "x86_64-linux" ];
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [
        WheelsForReals
      ];
      mainProgram = "parallel-launcher";
    };
  }
)
