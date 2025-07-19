{
  lib,
  stdenv,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  wayland,
  fcft,
  pixman,
  fetchFromGitea,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "dam";
  version = "0-unstable-2024-11-10";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "dam";
    rev = "be43694a6fdd72273fd9213fe0217c3d72315dbd";
    hash = "sha256-q4EbQh4OAKYIEbWS2R2yzps0gV/Hj3tljhRhs+JXXGs=";
  };

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

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Itsy-bitsy dwm-esque bar for river";
    homepage = "https://codeberg.org/sewn/dam";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ winterveil ];
  };
}
