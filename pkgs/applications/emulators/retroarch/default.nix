{ lib
, stdenv
, nixosTests
, enableNvidiaCgToolkit ? false
, withGamemode ? stdenv.isLinux
, withVulkan ? stdenv.isLinux
, withWayland ? stdenv.isLinux
, alsa-lib
, dbus
, fetchFromGitHub
, ffmpeg_4
, flac
, freetype
, gamemode
, libdrm
, libGL
, libGLU
, libpulseaudio
, libretro-core-info
, libv4l
, libX11
, libXdmcp
, libXext
, libxkbcommon
, libxml2
, libXxf86vm
, makeWrapper
, mbedtls
, mesa
, nvidia_cg_toolkit
, pkg-config
, python3
, SDL2
, substituteAll
, udev
, vulkan-loader
, wayland
, zlib
}:

let
  runtimeLibs =
    lib.optional withVulkan vulkan-loader ++
    lib.optional withGamemode (lib.getLib gamemode);
in
stdenv.mkDerivation rec {
  pname = "retroarch-bare";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    hash = "sha256-doLWNA8aTAllxx3zABtvZaegBQEPIi8276zbytPSdBU=";
    rev = "v${version}";
  };

  patches = [
    (substituteAll {
      src = ./use-fixed-path-for-libretro_core_info.patch;
      libretro_info_path = libretro-core-info;
    })
  ];

  nativeBuildInputs = [ pkg-config ] ++
    lib.optional withWayland wayland ++
    lib.optional (runtimeLibs != [ ]) makeWrapper;

  buildInputs = [
    ffmpeg_4
    flac
    freetype
    libGL
    libGLU
    libxml2
    mbedtls
    python3
    SDL2
    zlib
  ] ++
  lib.optional enableNvidiaCgToolkit nvidia_cg_toolkit ++
  lib.optional withVulkan vulkan-loader ++
  lib.optional withWayland wayland ++
  lib.optionals stdenv.isLinux [
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
    mesa
    udev
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-update_cores"
    "--disable-builtinmbedtls"
    "--disable-builtinzlib"
    "--disable-builtinflac"
  ] ++
  lib.optionals stdenv.isLinux [
    "--enable-dbus"
    "--enable-egl"
    "--enable-kms"
  ];

  postInstall = lib.optionalString (runtimeLibs != [ ]) ''
    wrapProgram $out/bin/retroarch \
      --prefix LD_LIBRARY_PATH ':' ${lib.makeLibraryPath runtimeLibs}
  '';

  preFixup = "rm $out/bin/retroarch-cg2glsl";

  passthru.tests = nixosTests.retroarch;

  meta = with lib; {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    changelog = "https://github.com/libretro/RetroArch/blob/v${version}/CHANGES.md";
    maintainers = with maintainers; teams.libretro.members ++ [ matthewbauer kolbycrouch ];
    mainProgram = "retroarch";
    # If you want to (re)-add support for macOS, see:
    # https://docs.libretro.com/development/retroarch/compilation/osx/
    # and
    # https://github.com/libretro/RetroArch/blob/71eb74d256cb4dc5b8b43991aec74980547c5069/.gitlab-ci.yml#L330
    broken = stdenv.isDarwin;
  };
}
