{ lib
, stdenv
, enableNvidiaCgToolkit ? false
, withGamemode ? stdenv.isLinux
, withVulkan ? stdenv.isLinux
, alsa-lib
, AppKit
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
, which
}:

let
  version = "1.10.2";
  libretroCoreInfo = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    sha256 = "sha256-XOSIVH3BSwAFKUeRvyYc2OXDa+TLjoKVGl+b8fgnvtY=";
    rev = "v${version}";
  };
  runtimeLibs = lib.optional withVulkan vulkan-loader
    ++ lib.optional withGamemode gamemode.lib;
in
stdenv.mkDerivation rec {
  pname = "retroarch-bare";
  inherit version;

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    sha256 = "sha256-fMsHMQiEoXeFKITxeEyRH829z5SCf8p0Hxq6ww1p3z4=";
    rev = "v${version}";
  };

  patches = [
    ./disable-menu_show_core_updater.patch
    ./use-fixed-paths-on-libretro_info_path.patch
  ];

  postPatch = ''
    substituteInPlace "frontend/drivers/platform_unix.c" \
      --replace "@libretro_directory@" "$out/lib" \
      --replace "@libretro_info_path@" "$out/share/libretro/info"
    substituteInPlace "frontend/drivers/platform_darwin.m" \
      --replace "@libretro_directory@" "$out/lib" \
      --replace "@libretro_info_path@" "$out/share/libretro/info"
  '';

  nativeBuildInputs = [ pkg-config ] ++
    lib.optional stdenv.isLinux wayland ++
    lib.optional (runtimeLibs != [ ]) makeWrapper;

  buildInputs = [ ffmpeg_4 freetype libxml2 libGLU libGL python3 SDL2 which ] ++
    lib.optional enableNvidiaCgToolkit nvidia_cg_toolkit ++
    lib.optional withVulkan vulkan-loader ++
    lib.optionals stdenv.isDarwin [ libobjc AppKit Foundation ] ++
    lib.optionals stdenv.isLinux [
      alsa-lib
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
      wayland
    ];

  enableParallelBuilding = true;

  configureFlags = lib.optionals stdenv.isLinux [ "--enable-kms" "--enable-egl" ];

  postInstall = ''
    mkdir -p $out/share/libretro/info
    # TODO: ideally each core should have its own core information
    cp -r ${libretroCoreInfo}/* $out/share/libretro/info
  '' + lib.optionalString (runtimeLibs != [ ]) ''
    wrapProgram $out/bin/retroarch \
      --prefix LD_LIBRARY_PATH ':' ${lib.makeLibraryPath runtimeLibs}
  '' + lib.optionalString stdenv.isDarwin ''
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
  NIX_CFLAGS_COMPILE = lib.optional stdenv.cc.isClang [ "-Wno-undef-prefix" ];

  meta = with lib; {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    changelog = "https://github.com/libretro/RetroArch/blob/v${version}/CHANGES.md";
    maintainers = with maintainers; [ MP2E edwtjo matthewbauer kolbycrouch thiagokokada ];
  };
}
