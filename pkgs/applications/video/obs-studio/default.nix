{ stdenv
, fetchFromGitHub
, cmake
, fdk_aac
, ffmpeg
, jansson
, libxkbcommon
, libpthreadstubs
, libXdmcp
, qtbase
, qtx11extras
, libv4l
, x264
, curl
, xorg
, makeWrapper
, pkgconfig

, alsaSupport ? false
, alsaLib
, pulseaudioSupport ? false
, libpulseaudio
}:

let
  optional = stdenv.lib.optional;
in stdenv.mkDerivation rec {
  name = "obs-studio-${version}";
  version = "19.0.3";

  src = fetchFromGitHub {
    owner = "jp9000";
    repo = "obs-studio";
    rev = "${version}";
    sha256 = "1qh69bw848l61fmh6n5q86yl3djmvzh76ln044ngi2k69a9bl94b";
  };

  patches = [ ./find-xcb.patch ];

  nativeBuildInputs = [ cmake
                        pkgconfig
                      ];

  buildInputs = [ curl
                  fdk_aac
                  ffmpeg
                  jansson
                  libv4l
                  libxkbcommon
                  libpthreadstubs
                  libXdmcp
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
    maintainers = with maintainers; [ jb55 MP2E ];
    license = licenses.gpl2;
    platforms = with platforms; linux;
  };
}
