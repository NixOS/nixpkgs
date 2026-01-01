{
  lib,
<<<<<<< HEAD
  gcc15Stdenv,
=======
  stdenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  cairo,
  file,
  hyprutils,
  libjpeg,
  libjxl,
  librsvg,
  libspng,
  libwebp,
  pango,
  pixman,
}:

<<<<<<< HEAD
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprgraphics";
  version = "0.5.0";
=======
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprgraphics";
  version = "0.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprgraphics";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-MRD+Jr2bY11MzNDfenENhiK6pvN+nHygxdHoHbZ1HtE=";
=======
    hash = "sha256-JnET78yl5RvpGuDQy3rCycOCkiKoLr5DN1fPhRNNMco=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    file
    hyprutils
    libjpeg
    libjxl
    librsvg
    libspng
    libwebp
    pango
    pixman
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/hyprwm/hyprgraphics";
    description = "Cpp graphics library for Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    teams = [ lib.teams.hyprland ];
  };
})
