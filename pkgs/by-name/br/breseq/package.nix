{
  stdenv,
  lib,
  fetchFromGitHub,
  callPackage,
  nix-update-script,
  libz,
  libtool,
  perl,
  R,
  bowtie2,
  which,
  ghostscript,
  makeWrapper,
  autoreconfHook,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "breseq";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "barricklab";
    repo = "breseq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DsDX2oGn7Ex50Wnp1phJjCziCzZIeeZOHriUGJbejsk=";
  };

  buildInputs = [
    perl
    libz
    libtool
  ];

  nativeBuildInputs = [
    makeWrapper
    autoreconfHook
  ];

  installPhase = ''
    runHook preInstall
    # Copy over binaries
    make install
    runHook postInstall
  '';

  postInstall = ''
    # Make wrappers
    wrapProgram $out/bin/breseq --prefix PATH : ${
      lib.makeBinPath [
        which
        ghostscript
        bowtie2
        R
      ]
    }
    wrapProgram $out/bin/gdtools --prefix PATH :  ${
      lib.makeBinPath [
        which
        ghostscript
        bowtie2
        R
      ]
    }
    # Copy over tests (incl necessary datasets) and license
    cp LICENSE $out/license
    mkdir $out/tests
    mkdir $out/tests/data
    cp tests/data/tmv_plasmid $out/tests/data/tmv_plasmid -r
    cp tests/data/lambda $out/tests/data/lambda -r
    cp tests/common.sh $out/tests/common.sh
    cp tests/tmv_plasmid_circular_deletion $out/tests/tmv_plasmid_circular_deletion -r
    cp tests/gdtools_compare_1 $out/tests/gdtools_compare_1 -r
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.tests = {
    breseq_works = callPackage ./tests/breseq.nix { };
    gdtools_works = callPackage ./tests/gdtools.nix { };
  };
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Computational pipeline for finding mutations relative to a reference sequence in short-read DNA re-sequencing data";
    mainProgram = "breseq";
    homepage = "https://github.com/barricklab/breseq";
    license = with lib.licenses; [
      gpl2Plus # See barricklab/breseq#398
    ];
    maintainers = with lib.maintainers; [ croots ];
    platforms = lib.platforms.all;
  };
})
