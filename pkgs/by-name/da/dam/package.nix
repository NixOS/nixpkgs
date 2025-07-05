{
  fetchFromGitea,
  lib,
  stdenv,
  pkg-config,
  wayland-protocols,
  wayland-scanner,
  wayland,
  fcft,
  pixman,
  patches ? [ ],
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dam";
  version = "0-unstable-2025-04-20";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "dam";
    rev = "ed8e349067";
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

  installFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://codeberg.org/sewn/dam";
    description = "Itsy-bitsy dwm-esque bar for river";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kkflt ];
    platforms = lib.platforms.linux;
  };
})
