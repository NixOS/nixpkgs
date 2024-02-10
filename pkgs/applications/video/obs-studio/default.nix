{ config
, lib
, stdenv
, fetchFromGitHub
, fetchpatch
, addOpenGLRunpath
, cmake
, fdk_aac
, ffmpeg
, jansson
, libjack2
, libxkbcommon
, libpthreadstubs
, libXdmcp
, qtbase
, qtsvg
, speex
, libv4l
, x264
, curl
, wayland
, xorg
, pkg-config
, libvlc
, libGL
, mbedtls
, wrapGAppsHook
, scriptingSupport ? true
, luajit
, swig4
, python3
, alsaSupport ? stdenv.isLinux
, alsa-lib
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio
, libcef
, pciutils
, pipewireSupport ? stdenv.isLinux
, withFdk ? true
, pipewire
, libdrm
, libajantv2
, librist
, libva
, srt
, qtwayland
, wrapQtAppsHook
, nlohmann_json
, websocketpp
, asio
, decklinkSupport ? false
, blackmagic-desktop-video
, libdatachannel
, libvpl
, qrcodegencpp
}:

let
  inherit (lib) optional optionals;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-studio";
  version = "30.0.2";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-8pX1kqibrtDIaE1+/Pey1A5bu6MwFTXLrBOah4rsF+4=";
    fetchSubmodules = true;
  };

  patches = [
    # Lets obs-browser build against CEF 90.1.0+
    ./Enable-file-access-and-universal-access-for-file-URL.patch
    ./fix-nix-plugin-path.patch

    # Backport ffmpeg 6.1 / GCC 13 build fixes
    # FIXME: remove in next release
    (fetchpatch {
      url = "https://github.com/obsproject/obs-studio/commit/cd784644f5e82b9988043f229c19603289c6d32c.patch";
      hash = "sha256-S4JE5kgr4x3uMHY2GRh0GBJpb7o/wYZb/v0CDITFNnQ=";
    })
    (fetchpatch {
      url = "https://github.com/obsproject/obs-studio/commit/758b47d4ed9a25b8d64ad481d8d039990b9e57c9.patch";
      hash = "sha256-jYpjwhx6e+dhN3kzbd6FcdjQ+WhIX0/BOu9PSkt+2yI=";
    })
    (fetchpatch {
      url = "https://github.com/obsproject/obs-studio/commit/4b5be75c7e4b8cee908ed4a02fe0078285b4e8c9.patch";
      hash = "sha256-tuOevhyxchwG42ilrplbiWoiDAKaY4HgzShlvp4VSQI=";
    })
    (fetchpatch {
      url = "https://github.com/obsproject/obs-studio/commit/6e080a68067b27fe5463f0f4eee7df690451f3d7.patch";
      hash = "sha256-nbn/q3uszoHaDvaW8Et1MS1sgQzMsJRmjGSMHzUxV70=";
    })

    # Fix libobs.pc for plugins on non-x86 systems
    (fetchpatch {
      name = "fix-arm64-cmake.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/obs-studio/broken-config.patch?id=a92887564dcc65e07b6be8a6224fda730259ae2b";
      hash = "sha256-yRSw4VWDwMwysDB3Hw/tsmTjEQUhipvrVRQcZkbtuoI=";
      includes = [ "*/CompilerConfig.cmake" ];
    })
  ];

  nativeBuildInputs = [
    addOpenGLRunpath
    cmake
    pkg-config
    wrapGAppsHook
    wrapQtAppsHook
  ]
  ++ optional scriptingSupport swig4;

  buildInputs = [
    curl
    ffmpeg
    jansson
    libcef
    libjack2
    libv4l
    libxkbcommon
    libpthreadstubs
    libXdmcp
    qtbase
    qtsvg
    speex
    wayland
    x264
    libvlc
    mbedtls
    pciutils
    libajantv2
    librist
    libva
    srt
    qtwayland
    nlohmann_json
    websocketpp
    asio
    libdatachannel
    libvpl
    qrcodegencpp
  ]
  ++ optionals scriptingSupport [ luajit python3 ]
  ++ optional alsaSupport alsa-lib
  ++ optional pulseaudioSupport libpulseaudio
  ++ optionals pipewireSupport [ pipewire libdrm ]
  ++ optional withFdk fdk_aac;

  # Copied from the obs-linuxbrowser
  postUnpack = ''
    mkdir -p cef/Release cef/Resources cef/libcef_dll_wrapper/
    for i in ${libcef}/share/cef/*; do
      ln -s $i cef/Release/
      ln -s $i cef/Resources/
    done
    ln -s ${libcef}/lib/libcef.so cef/Release/
    ln -s ${libcef}/lib/libcef_dll_wrapper.a cef/libcef_dll_wrapper/
    ln -s ${libcef}/include cef/
  '';

  cmakeFlags = [
    "-DOBS_VERSION_OVERRIDE=${finalAttrs.version}"
    "-Wno-dev" # kill dev warnings that are useless for packaging
    # Add support for browser source
    "-DBUILD_BROWSER=ON"
    "-DCEF_ROOT_DIR=../../cef"
    "-DENABLE_JACK=ON"
    (lib.cmakeBool "ENABLE_QSV11" stdenv.hostPlatform.isx86_64)
    (lib.cmakeBool "ENABLE_LIBFDK" withFdk)
    (lib.cmakeBool "ENABLE_ALSA" alsaSupport)
    (lib.cmakeBool "ENABLE_PULSEAUDIO" pulseaudioSupport)
    (lib.cmakeBool "ENABLE_PIPEWIRE" pipewireSupport)
  ];

  dontWrapGApps = true;
  preFixup = let
    wrapperLibraries = [
      xorg.libX11
      libvlc
      libGL
    ] ++ optionals decklinkSupport [
      blackmagic-desktop-video
    ];
  in ''
    # Remove libcef before patchelf, otherwise it will fail
    rm $out/lib/obs-plugins/libcef.so

    qtWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath wrapperLibraries}"
      ''${gappsWrapperArgs[@]}
    )
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    addOpenGLRunpath $out/lib/lib*.so
    addOpenGLRunpath $out/lib/obs-plugins/*.so

    # Link libcef again after patchelfing other libs
    ln -s ${libcef}/lib/* $out/lib/obs-plugins/
  '';

  meta = with lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    maintainers = with maintainers; [ eclairevoyant jb55 MP2E materus fpletz ];
    license = with licenses; [ gpl2Plus ] ++ optional withFdk fraunhofer-fdk;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    mainProgram = "obs";
  };
})
