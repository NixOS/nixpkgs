{stdenv, fetchurl, fetchFromGitHub, cmake, doxygen
, libX11, libXft, libXrandr, libXinerama, libXext, libXcursor, alsaLib}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libopenshot-audio-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${version}";
    sha256 = "0pgw7vzx3znglwm58187ybhg5maa13n4xcy5hrhzfsp8bqhrwkc7";
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
    maintainers = [maintainers.tohl];
    platforms = platforms.linux;
  };
}
