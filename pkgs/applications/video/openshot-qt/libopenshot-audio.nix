{ stdenv, fetchFromGitHub, pkgconfig, cmake, doxygen, alsaLib
, libX11, libXft, libXrandr, libXinerama, libXext, libXcursor }:

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
