{ lib
, stdenv
, nixosTests
, enableNvidiaCgToolkit ? false
, withGamemode ? stdenv.isLinux
, withVulkan ? stdenv.isLinux
, withWayland ? stdenv.isLinux
, alsa-lib
, AppKit
, dbus
, fetchFromGitHub
, ffmpeg_4
, Foundation
, freetype
, gamemode
, libdrm
, libGL
, libGLU
, libobjc
, libpulseaudio
, libv4l
, libX11
, libXdmcp
, libXext
, libxkbcommon
, libxml2
, libXxf86vm
, makeWrapper
, mesa
, nvidia_cg_toolkit
, pkg-config
, python3
, SDL2
, udev
, vulkan-loader
, wayland
}:

let
  version = "1.12.0";
  libretroCoreInfo = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    hash = "sha256-ByATDM0V40UJxigqVLyTWkHY5tiCC2dvZebksl8GsUI=";
    rev = "v${version}";
  };
  runtimeLibs =
    lib.optional withVulkan vulkan-loader ++
    lib.optional withGamemode (lib.getLib gamemode);
in
stdenv.mkDerivation rec {
  pname = "retroarch-bare";
  inherit version;

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    hash = "sha256-doLWNA8aTAllxx3zABtvZaegBQEPIi8276zbytPSdBU=";
    rev = "v${version}";
  };

  patches = [
    ./use-fixed-paths.patch
  ];

  postPatch = ''
    substituteInPlace "frontend/drivers/platform_unix.c" \
      --subst-var-by libretro_directory "$out/lib" \
      --subst-var-by libretro_info_path "$out/share/libretro/info" \
      --subst-var-by out "$out"
    substituteInPlace "frontend/drivers/platform_darwin.m" \
      --subst-var-by libretro_directory "$out/lib" \
      --subst-var-by libretro_info_path "$out/share/libretro/info"
  '';

  nativeBuildInputs = [ pkg-config ] ++
    lib.optional withWayland wayland ++
    lib.optional (runtimeLibs != [ ]) makeWrapper;

  buildInputs = [
    ffmpeg_4
    freetype
    libGL
    libGLU
    libxml2
    python3
    SDL2
  ] ++
  lib.optional enableNvidiaCgToolkit nvidia_cg_toolkit ++
  lib.optional withVulkan vulkan-loader ++
  lib.optional withWayland wayland ++
  lib.optionals stdenv.isDarwin [ libobjc AppKit Foundation ] ++
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
  ] ++
  lib.optionals stdenv.isLinux [
    "--enable-dbus"
    "--enable-egl"
    "--enable-kms"
  ];

  postInstall = ''
    # TODO: ideally each core should have its own core information
    mkdir -p $out/share/libretro/info
    cp -r ${libretroCoreInfo}/* $out/share/libretro/info
  '' +
  lib.optionalString (runtimeLibs != [ ]) ''
    wrapProgram $out/bin/retroarch \
      --prefix LD_LIBRARY_PATH ':' ${lib.makeLibraryPath runtimeLibs}
  '' +
  lib.optionalString stdenv.isDarwin ''
    # https://github.com/libretro/RetroArch/blob/master/retroarch-apple-packaging.sh
    app=$out/Applications/RetroArch.app
    mkdir -p $app/Contents/MacOS
    cp -r pkg/apple/OSX/* $app/Contents
    cp $out/bin/retroarch $app/Contents/MacOS
    # FIXME: using Info_Metal.plist results in input not working
    # mv $app/Contents/Info_Metal.plist $app/Contents/Info.plist

    substituteInPlace $app/Contents/Info.plist \
      --replace '${"\${EXECUTABLE_NAME}"}' 'RetroArch' \
      --replace '$(PRODUCT_BUNDLE_IDENTIFIER)' 'com.libretro.RetroArch' \
      --replace '${"\${PRODUCT_NAME}"}' 'RetroArch' \
      --replace '${"\${MACOSX_DEPLOYMENT_TARGET}"}' '10.13'

    cp media/retroarch.icns $app/Contents/Resources/
  '';

  preFixup = "rm $out/bin/retroarch-cg2glsl";

  # Workaround for the following error affecting newer versions of Clang:
  # ./config.def.h:xxx:x: error: 'TARGET_OS_TV' is not defined, evaluates to 0 [-Werror,-Wundef-prefix=TARGET_OS_]
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isClang [ "-Wno-undef-prefix" ];

  passthru.tests = nixosTests.retroarch;

  meta = with lib; {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    changelog = "https://github.com/libretro/RetroArch/blob/v${version}/CHANGES.md";
    maintainers = with maintainers; teams.libretro.members ++ [ matthewbauer kolbycrouch ];
    # FIXME: error while building in macOS:
    # "Undefined symbols for architecture <arch>"
    # See also retroarch/wrapper.nix that is also broken in macOS
    broken = stdenv.isDarwin;
  };
}
