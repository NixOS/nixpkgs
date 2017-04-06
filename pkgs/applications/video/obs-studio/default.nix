{ stdenv
, fetchFromGitHub
, cmake
, ffmpeg
, jansson
, libxkbcommon
, qtbase
, qtx11extras
, libv4l
, x264
, curl
, xorg
, makeWrapper

, alsaSupport ? false
, alsaLib
, pulseaudioSupport ? false
, libpulseaudio
}:

let
  optional = stdenv.lib.optional;
in stdenv.mkDerivation rec {
  name = "obs-studio-${version}";
  version = "18.0.1";

  src = fetchFromGitHub {
    owner = "jp9000";
    repo = "obs-studio";
    rev = "624aa2a5";
    sha256 = "1bs82rqyq7wjjg99mh23ap8z5bmrhjfnza5iyjx808fzqc0bgzaj";
  };

  nativeBuildInputs = [ cmake
                      ];

  buildInputs = [ curl
                  ffmpeg
                  jansson
                  libv4l
                  libxkbcommon
                  qtbase
                  qtx11extras
                  x264
                  makeWrapper
                ]
                ++ optional alsaSupport alsaLib
                ++ optional pulseaudioSupport libpulseaudio;

  # obs attempts to dlopen libobs-opengl, it fails unless we make sure
  # DL_OPENGL is an explicit path. Not sure if there's a better way
  # to handle this.
  cmakeFlags = [ "-DCMAKE_CXX_FLAGS=-DDL_OPENGL=\\\"$(out)/lib/libobs-opengl.so\\\"" ];

  postInstall = ''
      wrapProgram $out/bin/obs \
        --prefix "LD_LIBRARY_PATH" : "${xorg.libX11.out}/lib"
  '';

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
    platforms = with platforms; linux;
  };
}
