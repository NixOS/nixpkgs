{
  fetchgit,
  lib,
  stdenv,
  pkg-config,
  wayland-protocols,
  wayland-scanner,
  wayland,
  fcft,
  pixman,
  patches ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dam";
  version = "0-unstable-2025-4-20";

  src = fetchgit {
    url = "https://codeberg.org/sewn/dam.git";
    hash = "sha256-+DozBpc3vMQ/Wmp5WuYuL00lWCFQLUGMGPwtWiBZdqc=";
    fetchSubmodules = true;
  };

  inherit patches;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    fcft
    pixman
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://codeberg.org/sewn/dam";
    description = "Dam is a itsy-bitsy dwm-esque bar for river";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
