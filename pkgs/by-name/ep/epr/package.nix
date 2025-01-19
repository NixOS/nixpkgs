{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "epr";
  version = "2.4.13";

  src = fetchFromGitHub {
    owner = "wustho";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1qsqYlqGlCRhl7HINrcTDt5bGlb7g5PmaERylT+UvEg=";
  };

  meta = {
    description = "CLI Epub Reader";
    mainProgram = "epr";
    homepage = "https://github.com/wustho/epr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Br1ght0ne ];
    platforms = lib.platforms.all;
  };
}
