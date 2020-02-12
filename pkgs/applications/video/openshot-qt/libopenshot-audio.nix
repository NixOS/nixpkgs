{ stdenv, fetchFromGitHub, pkgconfig, cmake, doxygen, alsaLib , libX11, libXft, libXrandr, libXinerama, libXext, libXcursor }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "libopenshot-audio";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${version}";
    sha256 = "0mclxyb9vbyf76jrs5545cishgbkg0g44lass2ni557pyk3jagh3";
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
