{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  giza,
  hdf5,
  cairo,
  freetype,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "splash";
<<<<<<< HEAD
  version = "3.11.7";
=======
  version = "3.11.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "danieljprice";
    repo = "splash";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-V5p2MZIpM3uVww8sWzwRX4Df2z0tk15C4R3Jlzy7qEk=";
=======
    hash = "sha256-cnvsxHaTuz0xKOlGfWtjZDd/RDxNuurTNk03pTGYs78=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    gfortran
  ];

  buildInputs = [
    giza
    cairo
    freetype
    hdf5
  ];
  makeFlags = [
    "SYSTEM=gfortran"
    "GIZA_DIR=${giza}"
    "PREFIX=${placeholder "out"}"
  ];
  # Upstream's simplistic makefile doesn't even `mkdir $(PREFIX)`, so we help
  # it:
  preInstall = ''
    mkdir -p $out/bin
  '';
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Interactive visualisation and plotting tool using kernel interpolation, mainly used for Smoothed Particle Hydrodynamics simulations";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.all;
  };
})
