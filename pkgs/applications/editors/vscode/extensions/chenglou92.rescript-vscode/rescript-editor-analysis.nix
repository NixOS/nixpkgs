{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  ocamlPackages,
  dune_3,
  version,
}:

stdenv.mkDerivation {
  pname = "rescript-editor-analysis";
  inherit version;

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rescript-vscode";
    rev = version;
    hash = "sha256-+Ht8qWwxtFWHFMiV/aoZIs2S3SxkOWgdwSKN+akp/LU=";
  };

  nativeBuildInputs = [
    ocaml
    dune_3
    ocamlPackages.cppo
  ];

  # Skip testing phases because they need to download and install node modules
  postPatch = ''
    cd analysis
    substituteInPlace Makefile \
      --replace "build: build-analysis-binary build-reanalyze build-tests" "build: build-analysis-binary" \
      --replace "test: test-analysis-binary test-reanalyze" "test: test-analysis-binary"
  '';

  installPhase = ''
    install -D -m0555 rescript-editor-analysis.exe $out/bin/rescript-editor-analysis.exe
  '';

  meta = {
    description = "Analysis binary for the ReScript VSCode plugin";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = [
      lib.maintainers.dlip
      lib.maintainers.jayesh-bhoot
    ];
    license = lib.licenses.mit;
  };
}
