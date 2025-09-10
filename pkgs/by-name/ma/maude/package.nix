{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  makeWrapper,
  buddy,
  cln,
  cvc4,
  gmpxx,
  libsigsegv,
  tecla,
  yices,
  # passthru.tests
  tamarin-prover,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maude";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "maude-lang";
    repo = "Maude";
    tag = "Maude${finalAttrs.version}";
    hash = "sha256-NluckH48G4Y79exEQM+hB4oMujA2jcHUFgG3qe+9fGw=";
  };

  # Always enabled in CVC4 1.8: https://github.com/CVC4/CVC4/pull/4519
  postPatch = ''
    sed -i '/rewrite-divk/d' src/Mixfix/cvc4_Bindings.cc
  '';

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    makeWrapper
  ];

  buildInputs = [
    buddy
    cln
    cvc4
    gmpxx
    libsigsegv
    tecla
    yices
  ];

  hardeningDisable = [
    "stackprotector"
  ]
  ++ lib.optionals stdenv.hostPlatform.isi686 [
    "pic"
    "fortify"
  ];

  __darwinAllowLocalNetworking = true;

  configureScript = "../configure";

  configureFlags = [
    "--with-cvc4=yes"
    "--with-yices2=yes"
    "--prefix=${placeholder "out"}"
    "--datadir=${placeholder "out"}/share/maude"
  ];

  makeFlags = [ "CVC4_LIB=-lcvc4 -lcln" ];

  preConfigure = ''
    mkdir -p build
    cd build
  '';

  doCheck = true;

  postInstall = ''
    for n in "$out/bin/"*; do wrapProgram "$n" --suffix MAUDE_LIB ':' "$out/share/maude"; done
  '';

  passthru.tests = {
    # tamarin-prover only supports specific versions of maude explicitly
    inherit tamarin-prover;
  };

  enableParallelBuilding = true;

  meta = {
    homepage = "https://maude.cs.illinois.edu/";
    description = "High-level specification language";
    mainProgram = "maude";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      Maude is a high-performance reflective language and system
      supporting both equational and rewriting logic specification and
      programming for a wide range of applications. Maude has been
      influenced in important ways by the OBJ3 language, which can be
      regarded as an equational logic sublanguage. Besides supporting
      equational specification and programming, Maude also supports
      rewriting logic computation.
    '';
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.peti ];
  };
})
