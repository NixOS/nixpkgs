{ stdenv
, lib
, fetchFromGitHub
, libv4l
}:
stdenv.mkDerivation rec {
  pname = "openimajgrabber";
  version = "1.3.10";

  src = fetchFromGitHub {
    owner = "openimaj";
    repo = "openimaj";
    rev = "openimaj-${version}";
    sha256 = "sha256-Y8707ovE7f6Fk3cJ+PtwvzNpopgH5vlF55m2Xm4hjYM=";
  };

  buildInputs = [ libv4l ];

  # These build instructions come from build.sh
  buildPhase = ''
    pushd hardware/core-video-capture/src-native/linux
    g++ -fPIC -g -c OpenIMAJGrabber.cpp
    g++ -fPIC -g -c capture.cpp
    g++ -shared -Wl,-soname,OpenIMAJGrabber.so -o OpenIMAJGrabber.so OpenIMAJGrabber.o capture.o -lv4l2 -lrt -lv4lconvert
    popd
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp hardware/core-video-capture/src-native/linux/OpenIMAJGrabber.so $out/lib
  '';

  meta = with lib; {
    description = "Collection of libraries and tools for multimedia (images, text, video, audio, etc.) content analysis and content generation. This package only builds the OpenIMAJGrabber for Linux";
    homepage = "http://www.openimaj.org";
    license = licenses.bsd0;
    maintainers = with maintainers; [ emmanuelrosa _1000101 ];
    platforms = platforms.linux;
  };
}
