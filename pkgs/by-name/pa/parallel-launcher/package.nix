{
  lib,
  stdenv,
  callPackage,
  fetchFromGitLab,
  replaceVars,
  qt5,
  SDL2,
  discord-rpc,
  libgcrypt,
  sqlite,
  findutils,
  xdg-utils,
  coreutils,
  dosfstools,
  vulkan-loader,
  wrapRetroArch,
  retroarch-assets,
  parallel-launcher,
  # Allow overrides for the RetroArch core and declarative settings
  parallel-n64-core ? parallel-launcher.passthru.parallel-n64-core,
  extraRetroArchSettings ? { },
}:
let
  # Converts a version string like x.y.z to vx.y-z
  reformatVersion = v: "v${lib.versions.majorMinor v}-${lib.versions.patch v}";

  # Converts a version string like x.y.z to x, y, z
  reformatVersion' = lib.replaceStrings [ "." ] [ ", " ];

  retroArchAssetsPath = "${retroarch-assets}/share/retroarch/assets";
in
stdenv.mkDerivation (
  finalAttrs:
  let
    retroarch' = wrapRetroArch {
      cores = [
        parallel-n64-core
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
    version = "8.2.0"; # Check ./parallel-n64-next.nix for updates when updating, too

    src = fetchFromGitLab {
      owner = "parallel-launcher";
      repo = "parallel-launcher";
      tag = reformatVersion finalAttrs.version;
      hash = "sha256-G1ob2Aq/PE12jNO2YnlCdL9SWELj0Mf/vmr7dzNv550=";
    };

    patches =
      let
        retroArchCoresPath = "${retroarch'}/lib/retroarch/cores";
        suffix = stdenv.hostPlatform.extensions.sharedLibrary;
      in
      [
        # Fix FHS path assumptions
        (replaceVars ./fix-paths.patch {
          inherit retroArchAssetsPath retroArchCoresPath;
          retroArchExePath = lib.getExe retroarch';
          parallelN64CorePath = "${retroArchCoresPath}/parallel_n64_next_libretro${suffix}";
        })
        # Bypass update checks and hardcode internal version checks to ours
        (replaceVars ./fix-version-checks.patch {
          retroArchVersion = reformatVersion' (lib.getVersion retroarch');
          parallelN64CoreVersion = reformatVersion' (lib.getVersion parallel-n64-core);
        })
      ];

    nativeBuildInputs = [
      qt5.wrapQtAppsHook
      qt5.qttools
      qt5.qmake
    ];

    buildInputs = [
      SDL2
      discord-rpc
      libgcrypt
      sqlite
      qt5.qtbase
      qt5.qtsvg
    ];

    qtWrapperArgs = [
      "--prefix PATH : ${
        lib.makeBinPath [
          findutils
          xdg-utils
          coreutils
          dosfstools
        ]
      }"
      "--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          vulkan-loader
        ]
      }"
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

    passthru = {
      parallel-n64-core = callPackage ./parallel-n64-next.nix { };
      updateScript = {
        command = ./update.sh;
        supportedFeatures = [ "commit" ];
      };
    };

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
      # what nixpkgs RetroArch supports, and what the RetroArch core supports
      platforms = [ "x86_64-linux" ];
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [
        WheelsForReals
      ];
      mainProgram = "parallel-launcher";
    };
  }
)
