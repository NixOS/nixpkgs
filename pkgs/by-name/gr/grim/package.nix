{
  lib,
  fetchFromGitLab,
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
  version = "1.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "grim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oPo6zrS3gCnviIK0+gPvtal+6c7fNFWtXnAA0YfaS+U=";
  };

  depsBuildBuild = [
    # To find wayland-scanner
    pkg-config
  ];

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
    homepage = "https://gitlab.freedesktop.org/emersion/grim";
    description = "Grab images from a Wayland compositor";
    license = lib.licenses.mit;
    mainProgram = "grim";
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.linux;
  };
})
