{
  lib,
  stdenv,
  fetchFromGitLab,
  fsl-base,
  fsl-utils,
  fsl-armawrap,
  fsl-cprob,
  fsl-newnifti,
  fsl-znzlib,
  blas,
  lapack,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-miscmaths";
  version = "2412.6";

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "miscmaths";
    rev = finalAttrs.version;
    hash = "sha256-aZLrhyUtYNJIacoj61ekR4pJEzfv6VGpDGDmut5XS/0=";
  };

  buildInputs = [
    fsl-base
    fsl-utils
    fsl-armawrap
    fsl-cprob
    fsl-newnifti
    fsl-znzlib
    blas
    lapack
  ];

  buildPhase = ''
    export FSLDIR=${fsl-base}
    export FSLCONFDIR=${fsl-base}/config
    export FSLDEVDIR=$out
    make
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/include/miscmaths
    make FSLDEVDIR=$out install
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Miscellaneous maths library (part of FSL)";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/miscmaths";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
