{
  lib,
  stdenv,
  fetchFromGitLab,
  fsl-base,
  blas,
  lapack,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-cprob";
  version = "2111.0";

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "cprob";
    rev = finalAttrs.version;
    hash = "sha256-wsnYbpmIIWNOHC4Ev30xdPAeKIv4YxWEfWxIE8267NQ=";
  };

  buildInputs = [
    fsl-base
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
    mkdir -p $out/lib $out/include/cprob
    make FSLDEVDIR=$out install
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Probability distributions library (part of FSL)";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/cprob";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
