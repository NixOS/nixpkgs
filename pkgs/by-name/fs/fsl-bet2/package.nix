{
  lib,
  stdenv,
  fetchFromGitLab,
  makeWrapper,
  bc,
  fsl-base,
  fsl-utils,
  fsl-armawrap,
  fsl-cprob,
  fsl-newnifti,
  fsl-znzlib,
  fsl-miscmaths,
  fsl-newimage,
  fsl-meshclass,
  fsl-avwutils,
  python3Packages,
  blas,
  lapack,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-bet2";
  version = "2111.9";

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "bet2";
    rev = finalAttrs.version;
    hash = "sha256-9KI/gvEzfUER1YvxAu2z6TEIgQlaGNu2OWMi5PzUueI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    fsl-base
    fsl-utils
    fsl-armawrap
    fsl-cprob
    fsl-newnifti
    fsl-znzlib
    fsl-miscmaths
    fsl-newimage
    fsl-meshclass
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
    mkdir -p $out/bin
    make FSLDEVDIR=$out install
    runHook postInstall
  '';

  postInstall = ''
    rm -f $out/bin/Bet $out/bin/Bet_gui
    sed -i 's|''${FSLDIR}/bin/||g' $out/bin/bet
    sed -i 's|\$FSLDIR/bin/||g'    $out/bin/bet
    sed -i 's|/bin/rm |rm |g'      $out/bin/bet
    wrapProgram $out/bin/bet \
      --set-default FSLOUTPUTTYPE NIFTI_GZ \
      --set-default FSLDIR ${fsl-base} \
      --prefix PATH : ${lib.makeBinPath [ fsl-avwutils bc python3Packages.fslpy ]} \
      --prefix PATH : $out/bin
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FSL Brain Extraction Tool";
    homepage = "https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/BET";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    mainProgram = "bet";
    platforms = lib.platforms.linux;
  };
})
