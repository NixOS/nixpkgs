{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
}:

stdenv.mkDerivation {
  pname = "prover9";
  version = "2009-11A";

  src = fetchurl {
    url = "https://www.cs.unm.edu/~mccune/mace4/download/LADR-2009-11A.tar.gz";
    hash = "sha256-wyvtWAcADAtxYcJ25Q2coK8MskjfLBr/svb8AkcbUdA=";
  };

  hardeningDisable = [ "format" ];

  postPatch = ''
    RM=$(type -tp rm)
    MV=$(type -tp mv)
    CP=$(type -tp cp)
    for f in Makefile */Makefile; do
      substituteInPlace $f --replace-quiet "/bin/rm" "$RM" \
        --replace-quiet "/bin/mv" "$MV" \
        --replace-quiet "/bin/cp" "$CP";
    done
  '';

  buildFlags = [ "all" ];

  # Fails the build on clang-16 and gcc-14.
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-int";

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    make test1
    make test2
    make test3

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    for f in mace4 prover9 fof-prover9 autosketches4 newauto newsax ladr_to_tptp tptp_to_ladr; do
      install -Dm555 bin/$f $out/bin/$f;
    done
    install -Dm644 -t $out/share/man/man1 manpages/*.1
    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://www.cs.unm.edu/~mccune/mace4/";
    license = lib.licenses.gpl2Only;
    description = "Automated theorem prover for first-order and equational logic";
    longDescription = ''
      Prover9 is a resolution/paramodulation automated theorem prover
      for first-order and equational logic. Prover9 is a successor of
      the Otter Prover. This is the LADR command-line version.
    '';
    mainProgram = "prover9";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
