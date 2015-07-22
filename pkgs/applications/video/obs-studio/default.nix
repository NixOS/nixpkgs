{ stdenv
, fetchurl
, cmake
, ffmpeg
, jansson
, libxkbcommon
, qt5
, libv4l
, x264
, curl

, pulseaudioSupport ? false
, libpulseaudio
}:

let
  optional = stdenv.lib.optional;
in stdenv.mkDerivation rec {
  name = "obs-studio-${version}";
  version = "0.11.1";

  src = fetchurl {
    url = "https://github.com/jp9000/obs-studio/archive/${version}.tar.gz";
    sha256 = "12g1y6y8ixvgvwk75x7qgq0j06d5khd0w3if6kahswlc58q65fm8";
  };

  buildInputs = [ cmake
                  curl
                  ffmpeg
                  jansson
                  libv4l
                  libxkbcommon
                  qt5.base
                  qt5.x11extras
                  x264
                ]
                ++ optional pulseaudioSupport libpulseaudio;

  # obs attempts to dlopen libobs-opengl, it fails unless we make sure
  # DL_OPENGL is an explicit path. Not sure if there's a better way
  # to handle this.
  cmakeFlags = [ "-DCMAKE_CXX_FLAGS=-DDL_OPENGL=\\\"$(out)/lib/libobs-opengl.so\\\"" ];

  meta = with stdenv.lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.gpl2;
  };
}
