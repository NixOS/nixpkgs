{
  lib,
  stdenv,
  fetchFromGitLab,
  fsl-base,
  fsl-utils,
  zlib,
  bzip2,
  zstd,
  blas,
  lapack,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-znzlib";
  version = "2511.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "znzlib";
    rev = finalAttrs.version;
    hash = "sha256-DE1j6vg2Emie1pXAWEyAgOQbgbFVmMXzVfO4J23mcLQ=";
  };

  buildInputs = [
    fsl-base
    fsl-utils
    zlib
    bzip2
    zstd
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
    mkdir -p $out/lib $out/include/znzlib
    make FSLDEVDIR=$out install
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ZNZ compressed file I/O library (part of FSL)";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/znzlib";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
