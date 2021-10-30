{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, doxygen
, alsa-lib, libX11, libXft, libXrandr, libXinerama, libXext, libXcursor
, zlib, AGL, Cocoa, Foundation
}:

with lib;
stdenv.mkDerivation rec {
  pname = "libopenshot-audio";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${version}";
    sha256 = "13if0m5mvlqly8gmbhschzb9papkgp3yqivklhb949dhy16m8zgf";
  };

  nativeBuildInputs =
  [ pkg-config cmake doxygen ];

  buildInputs =
    optionals stdenv.isLinux [ alsa-lib ]
    ++ (if stdenv.isDarwin then
          [ zlib AGL Cocoa Foundation ]
        else
          [ libX11 libXft libXrandr libXinerama libXext libXcursor ])
  ;

  doCheck = false;

  meta = {
    homepage = "http://openshot.org/";
    description = "High-quality sound editing library";
    longDescription = ''
      OpenShot Audio Library (libopenshot-audio) is a program that allows the
      high-quality editing and playback of audio, and is based on the amazing
      JUCE library.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
