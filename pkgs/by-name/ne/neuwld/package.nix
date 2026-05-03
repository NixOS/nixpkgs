{
  doxygen,
  fetchFromSourcehut,
  fontconfig,
  lib,
  libdrm,
  meson,
  ninja,
  nix-update-script,
  pixman,
  pkg-config,
  stdenv,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neuwld";
  version = "0-unstable-2026-03-18";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuwld";
    rev = "6446a28168045efffa8ccd3de0b6eb3599fb5339";
    hash = "sha256-rP03qodS9zUKJ6WPxPlu/sn+yRWc6jssa10mVPEjodc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    doxygen
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fontconfig
    libdrm
    pixman
    wayland
    wayland-scanner
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Drawing library that targets Wayland";
    homepage = "https://git.sr.ht/~shrub900/neuwld";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ricardomaps
      yiyu
    ];
    platforms = lib.platforms.all;
  };
})
