{stdenv, fetchurl, fetchFromGitHub, cmake, doxygen
, libX11, libXft, libXrandr, libXinerama, libXext, libXcursor, alsaLib}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libopenshot-audio-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${version}";
    sha256 = "0dxyhnqkjc5y4hra8s17q9lafll6fx0pgibmmjznjm70whqcj8a6";
  };

  buildInputs = [
    cmake doxygen
    libX11 libXft libXrandr libXinerama libXext libXcursor alsaLib
  ];

  doCheck = false;

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor";
    license = licenses.gpl3Plus;
    maintainers = [];
    platforms = platforms.linux;
  };
}
