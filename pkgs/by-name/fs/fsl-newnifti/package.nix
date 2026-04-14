{
  lib,
  stdenv,
  fetchFromGitLab,
  fsl-base,
  fsl-utils,
  fsl-znzlib,
  blas,
  lapack,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-newnifti";
  version = "5.0.0";

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "newnifti";
    rev = finalAttrs.version;
    hash = "sha256-vtboEezMrdg3ZnCWjFYB06X7p6rgTXnz+BbTU4OWE4s=";
  };

  buildInputs = [
    fsl-base
    fsl-utils
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
    mkdir -p $out/lib $out/include/NewNifti
    make FSLDEVDIR=$out install
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "NIfTI-2 image I/O library (part of FSL)";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/newnifti";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
