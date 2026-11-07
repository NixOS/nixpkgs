{
  lib,
  buildGoModule,
  fetchFromGitHub,
  bash,
}:

buildGoModule (finalAttrs: {
  pname = "rye-lang";
  version = "0.0.96";

  src = fetchFromGitHub {
    owner = "refaktor";
    repo = "rye";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ef9tGx3u8lhy2k0VVBKGmmKPBBoW1mCi1lecj0Jyak8=";
  };

  vendorHash = "sha256-cmZ+3hQUHDkpex8H7pSdyFtMHyhwyur69CBS3CV/5rU=";

  buildInputs = [
    bash
  ];

  buildPhase = ''
    runHook preBuild
    go build -o $GOPATH/bin/rye
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    cd tests/
    patchShebangs *
    $GOPATH/bin/rye . test
    runHook postCheck
  '';

  meta = {
    description = "High-level, dynamic programming language inspired by Rebol, Factor, Linux shells, and Go.";
    homepage = "https://github.com/refaktor/rye";
    license = lib.licenses.bsd3;
    mainProgram = "rye";
    maintainers = [ ];
  };
})
