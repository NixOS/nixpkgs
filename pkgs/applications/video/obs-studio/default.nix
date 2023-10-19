{ config
, lib
, stdenv
, fetchFromGitHub
, addOpenGLRunpath
, cmake
, fdk_aac
, ffmpeg_4
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
}:

let
  inherit (lib) optional optionals;

in
stdenv.mkDerivation rec {
  pname = "obs-studio";
  version = "29.1.3";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    rev = version;
    sha256 = "sha256-D0DPueMtopwz5rLgM8QcPT7DgTKcJKQHnst69EY9V6Q=";
    fetchSubmodules = true;
  };

  patches = [
    # Lets obs-browser build against CEF 90.1.0+
    ./Enable-file-access-and-universal-access-for-file-URL.patch
    ./fix-nix-plugin-path.patch
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
    fdk_aac
    ffmpeg_4
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
  ]
  ++ optionals scriptingSupport [ luajit python3 ]
  ++ optional alsaSupport alsa-lib
  ++ optional pulseaudioSupport libpulseaudio
  ++ optionals pipewireSupport [ pipewire libdrm ];

  # Copied from the obs-linuxbrowser
  postUnpack = ''
    mkdir -p cef/Release cef/Resources cef/libcef_dll_wrapper/
    for i in ${libcef}/share/cef/*; do
      cp -r $i cef/Release/
      cp -r $i cef/Resources/
    done
    cp -r ${libcef}/lib/libcef.so cef/Release/
    cp -r ${libcef}/lib/libcef_dll_wrapper.a cef/libcef_dll_wrapper/
    cp -r ${libcef}/include cef/
  '';

  cmakeFlags = [
    "-DOBS_VERSION_OVERRIDE=${version}"
    "-Wno-dev" # kill dev warnings that are useless for packaging
    # Add support for browser source
    "-DBUILD_BROWSER=ON"
    "-DCEF_ROOT_DIR=../../cef"
    "-DENABLE_JACK=ON"
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
    qtWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath wrapperLibraries}"
      ''${gappsWrapperArgs[@]}
    )
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    addOpenGLRunpath $out/lib/lib*.so
    addOpenGLRunpath $out/lib/obs-plugins/*.so
  '';

  meta = with lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    maintainers = with maintainers; [ jb55 MP2E V materus ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    mainProgram = "obs";
  };
}
