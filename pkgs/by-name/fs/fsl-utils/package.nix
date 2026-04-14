{
  lib,
  stdenv,
  fetchFromGitLab,
  fsl-base,
  fsl-armawrap,
  armadillo,
  blas,
  lapack,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-utils";
  version = "2412.6";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "utils";
    rev = finalAttrs.version;
    hash = "sha256-XfLEEzBHjvva3rBTgJSrIxbKnVA0caiYgttCk5EDs5s=";
  };

  buildInputs = [
    fsl-base
    fsl-armawrap
    armadillo
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
    mkdir -p $out/lib $out/include/utils
    make FSLDEVDIR=$out install
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FSL utilities library";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/utils";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
