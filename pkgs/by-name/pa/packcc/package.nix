{
  bats,
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  python3,
  stdenv,
  uncrustify,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "packcc";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "arithy";
    repo = "packcc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uRvZr6mw9eI0a4JxFwDNyPBIrwTHgq3KmarDP/NmrEs=";
  };

  postPatch = ''
    # Remove broken tests.
    rm -rf \
      tests/ast-calc.v3.d \
      tests/style.d
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  doCheck = true;
  checkTarget = "check";
  nativeCheckInputs = [
    bats
    python3
    uncrustify
  ];

  doInstallCheck = true;
  installCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Parser generator for C";
    longDescription = ''
      PackCC is a parser generator for C. Its main features are as follows:
      - Generates your parser in C from a grammar described in a PEG,
      - Gives your parser great efficiency by packrat parsing,
      - Supports direct and indirect left-recursive grammar rules.
    '';
    homepage = "https://github.com/arithy/packcc";
    changelog = "https://github.com/arithy/packcc/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.unix;
    mainProgram = "packcc";
  };
})
