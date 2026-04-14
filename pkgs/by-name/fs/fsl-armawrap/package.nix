{
  lib,
  stdenv,
  fetchFromGitLab,
  fsl-base,
  armadillo,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-armawrap";
  version = "0.7.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "armawrap";
    rev = finalAttrs.version;
    hash = "sha256-I13c2WtwV4rT63T9iP6VkVQ5uw9i2Sh9sfL797xBw7Y=";
  };

  buildInputs = [
    fsl-base
    armadillo
  ];

  buildPhase = ''
    export FSLDIR=${fsl-base}
    export FSLCONFDIR=${fsl-base}/config
    export FSLDEVDIR=$out
    make
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include
    make FSLDEVDIR=$out install
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Armadillo wrapper library used by FSL";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/armawrap";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
