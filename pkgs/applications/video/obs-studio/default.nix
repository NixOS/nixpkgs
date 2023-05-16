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
<<<<<<< HEAD
, libGL
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mbedtls
, wrapGAppsHook
, scriptingSupport ? true
, luajit
<<<<<<< HEAD
, swig4
=======
, swig
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, nlohmann_json
, websocketpp
, asio
, decklinkSupport ? false
, blackmagic-desktop-video
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  inherit (lib) optional optionals;

in
stdenv.mkDerivation rec {
  pname = "obs-studio";
<<<<<<< HEAD
  version = "29.1.3";
=======
  version = "29.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-D0DPueMtopwz5rLgM8QcPT7DgTKcJKQHnst69EY9V6Q=";
=======
    sha256 = "sha256-TIUSjyPEsKRNTSLQXuLJGEgD989hJ5GhOsqJ4nkKVsY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  patches = [
    # Lets obs-browser build against CEF 90.1.0+
    ./Enable-file-access-and-universal-access-for-file-URL.patch
<<<<<<< HEAD
    ./fix-nix-plugin-path.patch
=======
    ./Provide-runtime-plugin-destination-as-relative-path.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs = [
    addOpenGLRunpath
    cmake
    pkg-config
    wrapGAppsHook
    wrapQtAppsHook
  ]
<<<<<<< HEAD
  ++ optional scriptingSupport swig4;
=======
  ++ optional scriptingSupport swig;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    nlohmann_json
    websocketpp
    asio
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  cmakeFlags = [
=======
  # obs attempts to dlopen libobs-opengl, it fails unless we make sure
  # DL_OPENGL is an explicit path. Not sure if there's a better way
  # to handle this.
  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-DDL_OPENGL=\\\"$(out)/lib/libobs-opengl.so\\\""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "-DOBS_VERSION_OVERRIDE=${version}"
    "-Wno-dev" # kill dev warnings that are useless for packaging
    # Add support for browser source
    "-DBUILD_BROWSER=ON"
    "-DCEF_ROOT_DIR=../../cef"
    "-DENABLE_JACK=ON"
  ];

  dontWrapGApps = true;
<<<<<<< HEAD
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
=======
  preFixup = ''
    qtWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ xorg.libX11 libvlc ]}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ jb55 MP2E V ];
=======
    maintainers = with maintainers; [ jb55 MP2E V miangraham ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    mainProgram = "obs";
  };
}
