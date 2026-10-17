{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  udev,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmonome";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "monome";
    repo = "libmonome";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a5r8HrR2x8NdC8E1fz+4fuEk+2CGDTYcJdIVZfX9hCA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ udev ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C library for interacting with monome devices (grids, arcs)";
    homepage = "https://github.com/monome/libmonome";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
})
