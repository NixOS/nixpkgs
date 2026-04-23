{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  cctools,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prover9";
  version = "2026-3K";

  src = fetchFromGitHub {
    owner = "AlgorithmicTruth";
    repo = "Prover9";
    tag = "LADR-${finalAttrs.version}";
    hash = "sha256-1qK0GXF/KFzjt9+/T7+IWyi2QEjNjt5JZ3nvRdTKnYc=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  makeFlags = [
    "CC=${lib.getExe stdenv.cc}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "PLATFORM_FLAGS="
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-int"
    "-Wno-error=implicit-function-declaration"
    (lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=return-type")
  ];

  postPatch = ''
    for f in Makefile */Makefile; do
      substituteInPlace $f \
        --replace-quiet "/bin/rm" ${lib.getExe' coreutils "rm"} \
        --replace-quiet "/bin/mv" ${lib.getExe' coreutils "mv"} \
        --replace-quiet "/bin/cp" ${lib.getExe' coreutils "cp"}
    done
  '';

  buildFlags = [ "all" ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    make test1 test2 test3
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    for f in mace4 prover9 fof-prover9 autosketches4 newauto newsax ladr_to_tptp tptp_to_ladr; do
      install -Dm555 bin/$f $out/bin/$f
    done
    install -Dm644 -t $out/share/man/man1 manpages/*.1
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://prover9.org/";
    license = lib.licenses.gpl2Only;
    description = "Automated theorem prover for first-order and equational logic";
    mainProgram = "prover9";
    platforms = lib.platforms.unix;
    maintainers = [ "manmatteo" ];
  };
})
