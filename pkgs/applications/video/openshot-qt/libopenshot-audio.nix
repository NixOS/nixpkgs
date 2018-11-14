{ stdenv, fetchFromGitHub, pkgconfig, cmake, doxygen, alsaLib
, libX11, libXft, libXrandr, libXinerama, libXext, libXcursor }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libopenshot-audio-${version}";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${version}";
    sha256 = "08a8wbi28kwrdz4h0rs1b9vsr28ldfi8g75q54rj676y1vwg3qys";
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
