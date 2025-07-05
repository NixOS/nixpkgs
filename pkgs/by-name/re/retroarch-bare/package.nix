{
  lib,
  stdenv,
  # deps
  alsa-lib,
  dbus,
  fetchFromGitHub,
  ffmpeg,
  flac,
  freetype,
  gamemode,
  gitUpdater,
  libdrm,
  libGL,
  libGLU,
  libpulseaudio,
  libv4l,
  libX11,
  libXdmcp,
  libXext,
  libxkbcommon,
  libxml2,
  libXxf86vm,
  makeBinaryWrapper,
  mbedtls_2,
  libgbm,
  nixosTests,
  nvidia_cg_toolkit,
  pipewire,
  pkg-config,
  python3,
  qt5,
  SDL2,
  spirv-tools,
  udev,
  vulkan-loader,
  wayland,
  wayland-scanner,
  zlib,
  # wrapper deps
  libretro,
  libretro-core-info,
  retroarch-assets,
  retroarch-bare,
  retroarch-joypad-autoconfig,
  runCommand,
  symlinkJoin,
  # params
  enableNvidiaCgToolkit ? false,
  withGamemode ? stdenv.hostPlatform.isLinux,
  withVulkan ? stdenv.hostPlatform.isLinux,
  withWayland ? stdenv.hostPlatform.isLinux,
}:

let
  runtimeLibs =
    lib.optional withVulkan vulkan-loader
    ++ lib.optional withGamemode (lib.getLib gamemode);
in
stdenv.mkDerivation rec {
  pname = "retroarch-bare";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    hash = "sha256-OewUmnYpRByOgTi42G2reoaSuwxyPGHwP0+Uts/pg54=";
    rev = "v${version}";
  };

  nativeBuildInputs =
    [
      pkg-config
      qt5.wrapQtAppsHook
    ]
    ++ lib.optional withWayland wayland
    ++ lib.optional (runtimeLibs != [ ]) makeBinaryWrapper;

  buildInputs =
    [
      ffmpeg
      flac
      freetype
      libGL
      libGLU
      libxml2
      mbedtls_2
      python3
      qt5.qtbase
      SDL2
      spirv-tools
      zlib
    ]
    ++ lib.optional enableNvidiaCgToolkit nvidia_cg_toolkit
    ++ lib.optional withVulkan vulkan-loader
    ++ lib.optionals withWayland [
      wayland
      wayland-scanner
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      dbus
      libX11
      libXdmcp
      libXext
      libXxf86vm
      libdrm
      libpulseaudio
      libv4l
      libxkbcommon
      libgbm
      pipewire
      udev
    ];

  enableParallelBuilding = true;

  configureFlags =
    [
      "--disable-update_cores"
      "--disable-builtinmbedtls"
      "--enable-systemmbedtls"
      "--disable-builtinzlib"
      "--disable-builtinflac"
      "--disable-update_assets"
      "--disable-update_core_info"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--enable-dbus"
      "--enable-egl"
      "--enable-kms"
    ];

  postInstall =
    lib.optionalString (runtimeLibs != [ ]) ''
      wrapProgram $out/bin/retroarch \
        --prefix LD_LIBRARY_PATH ':' ${lib.makeLibraryPath runtimeLibs}
    ''
    + lib.optionalString enableNvidiaCgToolkit ''
      wrapProgram $out/bin/retroarch-cg2glsl \
        --prefix PATH ':' ${lib.makeBinPath [ nvidia_cg_toolkit ]}
    '';

  preFixup = lib.optionalString (!enableNvidiaCgToolkit) ''
    rm $out/bin/retroarch-cg2glsl
    rm $out/share/man/man6/retroarch-cg2glsl.6*
  '';

  passthru = {
    tests = nixosTests.retroarch;
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
    wrapper =
      {
        cores ? [ ],
        settings ? { },
      }:
      import ./wrapper.nix {
        inherit
          lib
          libretro
          makeBinaryWrapper
          retroarch-bare
          runCommand
          symlinkJoin
          cores
          ;
        settings = {
          assets_directory = "${retroarch-assets}/share/retroarch/assets";
          joypad_autoconfig_dir = "${retroarch-joypad-autoconfig}/share/libretro/autoconfig";
          libretro_info_path = "${libretro-core-info}/share/retroarch/cores";
        } // settings;
      };
  };

  meta = {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    changelog = "https://github.com/libretro/RetroArch/blob/v${version}/CHANGES.md";
    maintainers = with lib.maintainers; [
      matthewbauer
      kolbycrouch
    ];
    teams = [ lib.teams.libretro ];
    mainProgram = "retroarch";
    # If you want to (re)-add support for macOS, see:
    # https://docs.libretro.com/development/retroarch/compilation/osx/
    # and
    # https://github.com/libretro/RetroArch/blob/71eb74d256cb4dc5b8b43991aec74980547c5069/.gitlab-ci.yml#L330
    broken = stdenv.hostPlatform.isDarwin;
  };
}
