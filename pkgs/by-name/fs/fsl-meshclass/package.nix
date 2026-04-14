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
  fsl-miscmaths,
  fsl-newimage,
  blas,
  lapack,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-meshclass";
  version = "2111.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "meshclass";
    rev = finalAttrs.version;
    hash = "sha256-ALpAVSHijfiCI8vvAdPgzWSGXyw2zTMBz0SHj5EzAs8=";
  };

  buildInputs = [
    fsl-base
    fsl-utils
    fsl-armawrap
    fsl-cprob
    fsl-newnifti
    fsl-znzlib
    fsl-miscmaths
    fsl-newimage
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
    mkdir -p $out/lib $out/include/meshclass $out/bin
    make FSLDEVDIR=$out install
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FSL mesh class library";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/meshclass";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
