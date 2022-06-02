{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, cmake
, doxygen
, libX11
, libXcursor
, libXext
, libXft
, libXinerama
, libXrandr
, pkg-config
, zlib
, AGL
, Cocoa
, Foundation
}:

stdenv.mkDerivation rec {
  pname = "libopenshot-audio";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${version}";
    sha256 = "sha256-XtwTZsj/L/sw/28E7Qr5UyghGlBFFXvbmZLGXBB8vg0=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ (if stdenv.isDarwin then [
      AGL
      Cocoa
      Foundation
      zlib
    ] else [
      libX11
      libXcursor
      libXext
      libXft
      libXinerama
      libXrandr
    ]);

  doCheck = false;

  meta = with lib; {
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
