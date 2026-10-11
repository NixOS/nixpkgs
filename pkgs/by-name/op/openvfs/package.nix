{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fuse3,
  kdePackages,
  nix-update-script,
  nlohmann_json,
  qt6,
}:
#
stdenv.mkDerivation (finalAttrs: {
  pname = "openvfs";
  version = "0.1.0-unstable-2026-09-09";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "openvfs";
    rev = "56fc0514d09875f0ab8c754d8242318ab47e584f";
    hash = "sha256-NeIuatnvTCHakZU1JhwuX4euXevXNglmEdrH0QaYqYg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    fuse3
    kdePackages.extra-cmake-modules
    nlohmann_json
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Virtual Filesystem Layer for cloud storages for the free desktop (FUSE based files-on-demand)";
    homepage = "https://github.com/opencloud-eu/openvfs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "openvfs";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.linux;
  };
})
