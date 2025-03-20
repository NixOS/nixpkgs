{
  lib,
  fetchFromSourcehut,
  libjpeg,
  libpng,
  meson,
  ninja,
  pixman,
  pkg-config,
  scdoc,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grim";
  version = "1.4.1";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "grim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5csJqRLNqhyeXR4dEQtnPUSwuZ8oY+BIt6AVICkm1+o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    pixman
    libpng
    libjpeg
    wayland
    wayland-protocols
  ];

  mesonFlags = [ (lib.mesonBool "werror" false) ];

  strictDeps = true;

  meta = {
    homepage = "https://sr.ht/~emersion/grim";
    description = "Grab images from a Wayland compositor";
    license = lib.licenses.mit;
    mainProgram = "grim";
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.linux;
  };
})
