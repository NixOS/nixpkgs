{ stdenv
, fetchurl
, cmake
, ffmpeg
, jansson
, libxkbcommon
, qt5
, libv4l
, x264

, pulseaudioSupport ? false
, libpulseaudio
}:

let
  optional = stdenv.lib.optional;
in stdenv.mkDerivation rec {
  name = "obs-studio-${version}";
  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/jp9000/obs-studio/archive/${version}.tar.gz";
    sha256 = "1xms48gl20pr9g8bv8ygykh6m99c3wjphsavr4hb1d5263r9f4in";
  };

  buildInputs = [ cmake
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
