{ lib
, stdenv
, fetchFromGitHub
, cmake
, makeWrapper
, libX11
, libXrandr
, linuxPackages
}:

stdenv.mkDerivation rec {
  pname = "libvibrant";
  version = "2100c09";

  src = fetchFromGitHub {
    owner = "libvibrant";
    repo = "libvibrant";
    rev = version;
    hash = "sha256-nVODwP/PQgYBTHnSplgrkdNOLsF7N+vZ8iPL7gArVNY=";
  };

  buildInputs = [ libX11 libXrandr linuxPackages.nvidia_x11.settings.libXNVCtrl ];
  nativeBuildInputs = [ cmake makeWrapper ];

  meta = with lib; {
    description = "A simple library to adjust color saturation of X11 outputs";
    homepage = "https://github.com/libvibrant/libvibrant";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "vibrant-cli";
  };
}
