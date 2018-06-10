{ stdenv, fetchFromGitHub, pkgconfig, cmake, doxygen, alsaLib
, libX11, libXft, libXrandr, libXinerama, libXext, libXcursor }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libopenshot-audio-${version}";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${version}";
    sha256 = "0rn87jxyfq1yip1lb2255l5ilkakkqg9rn0lr0h6dn2xrmlbmg8l";
  };

  nativeBuildInputs =
  [ pkgconfig cmake doxygen ];

  buildInputs =
  [ alsaLib libX11 libXft libXrandr libXinerama libXext libXcursor ];

  doCheck = false;

  meta = {
    homepage = http://openshot.org/;
    description = "High-quality sound editing library";
    longDescription = ''
      OpenShot Audio Library (libopenshot-audio) is a program that allows the
      high-quality editing and playback of audio, and is based on the amazing
      JUCE library.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
