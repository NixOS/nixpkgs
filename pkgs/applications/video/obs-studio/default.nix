{ config, stdenv
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
, xorg
, makeWrapper
, pkgconfig
, libvlc
, mbedtls

, scriptingSupport ? true
, luajit
, swig
, python3

, alsaSupport ? stdenv.isLinux
, alsaLib
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio
, libcef
}:

let
  inherit (stdenv.lib) optional optionals;

in mkDerivation rec {
  pname = "obs-studio";
  version = "26.0.2";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    rev = "refs/tags/${version}";
    sha256 = "1bf56z2yb7gq1knqwcqj369c3wl9jr3wll5vlngmfy2gwqrczjmw";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ addOpenGLRunpath cmake pkgconfig ];

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
    x264
    libvlc
    makeWrapper
    mbedtls
  ]
  ++ optionals scriptingSupport [ luajit swig python3 ]
  ++ optional alsaSupport alsaLib
  ++ optional pulseaudioSupport libpulseaudio;

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

  postInstall = ''
      wrapProgram $out/bin/obs \
        --prefix "LD_LIBRARY_PATH" : "${xorg.libX11.out}/lib:${libvlc}/lib"
  '';

  postFixup = stdenv.lib.optionalString stdenv.isLinux ''
      addOpenGLRunpath $out/lib/lib*.so
      addOpenGLRunpath $out/lib/obs-plugins/*.so
  '';

  meta = with stdenv.lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    maintainers = with maintainers; [ jb55 MP2E ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
