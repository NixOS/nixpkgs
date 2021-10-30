{ config
, lib
, stdenv
, mkDerivation
, fetchFromGitHub
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
, qtx11extras
, qtsvg
, speex
, libv4l
, x264
, curl
, wayland
, xorg
, makeWrapper
, pkg-config
, libvlc
, mbedtls

, scriptingSupport ? true
, luajit
, swig
, python3

, alsaSupport ? stdenv.isLinux
, alsa-lib
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio
, libcef
, pipewireSupport ? stdenv.isLinux
, pipewire
}:

let
  inherit (lib) optional optionals;

in
mkDerivation rec {
  pname = "obs-studio";
  version = "27.0.1";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    rev = version;
    sha256 = "04fzsr9yizmxy0r7z2706crvnsnybpnv5kgfn77znknxxjacfhkn";
    fetchSubmodules = true;
  };

  patches = [
    # Lets obs-browser build against CEF 90.1.0+
    ./Enable-file-access-and-universal-access-for-file-URL.patch

    # Lets obs-browser build against CEF 91.1.0+
    ./Change-product_version-to-user_agent_product.patch
  ];

  nativeBuildInputs = [
    addOpenGLRunpath
    cmake
    pkg-config
    makeWrapper
  ]
  ++ optional scriptingSupport swig;

  buildInputs = [
    curl
    fdk_aac
    ffmpeg
    jansson
    libcef
    libjack2
    libv4l
    libxkbcommon
    libpthreadstubs
    libXdmcp
    qtbase
    qtx11extras
    qtsvg
    speex
    wayland
    x264
    libvlc
    mbedtls
  ]
  ++ optionals scriptingSupport [ luajit python3 ]
  ++ optional alsaSupport alsa-lib
  ++ optional pulseaudioSupport libpulseaudio
  ++ optional pipewireSupport pipewire;

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

  # obs attempts to dlopen libobs-opengl, it fails unless we make sure
  # DL_OPENGL is an explicit path. Not sure if there's a better way
  # to handle this.
  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-DDL_OPENGL=\\\"$(out)/lib/libobs-opengl.so\\\""
    "-DOBS_VERSION_OVERRIDE=${version}"
    "-Wno-dev" # kill dev warnings that are useless for packaging
    # Add support for browser source
    "-DBUILD_BROWSER=ON"
    "-DCEF_ROOT_DIR=../../cef"
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ xorg.libX11 libvlc ]}"
  ];

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
    maintainers = with maintainers; [ jb55 MP2E V ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };
}
