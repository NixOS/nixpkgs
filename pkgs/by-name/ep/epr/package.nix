{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "epr";
  version = "2.4.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wustho";
    repo = "epr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1qsqYlqGlCRhl7HINrcTDt5bGlb7g5PmaERylT+UvEg=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  meta = {
    description = "CLI Epub Reader";
    mainProgram = "epr";
    homepage = "https://github.com/wustho/epr";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
