{
  lib,
  stdenv,
  fetchFromGitHub,
  festival,
  runCommand,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "festival-czech";
  version = "0.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    repo = "festival-czech";
    owner = "brailcom";
    rev = "98a98ac63d74d2fd2b980110509639245f3fcb52";
    hash = "sha256-zi06+R+AHbYAFktfYuopgxErknYyvEFcFV4LJefp0cc=";
  };

  dontConfigure = true;
  dontFixup = true;

  buildInputs = [ festival ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace-fail 'festival --batch' '${festival}/bin/festival --batch'
  '';

  makeFlags = [ ];

  buildFlags = [ "all" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp *.scm *.out $out/lib

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/czech.scm \
      --replace-fail \
        '(defvar czech-lexicon-file "czech-lexicon.out")' \
        '(defvar czech-lexicon-file "${placeholder "out"}/lib/czech-lexicon.out")'
  '';

  passthru.tests.stub = runCommand "stub-test" ''
    mkdir $out
  '';

  meta = {
    description = "festival-czech is a depencency for all Festival Czech voices";
    homepage = "https://freebsoft.org/festival-czech";
    license = with lib.licenses; [ lgpl21Only ];
    maintainers = with lib.maintainers; [ WiredMic ];
  };
})
