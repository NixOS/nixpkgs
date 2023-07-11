{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "epr";
  version = "2.4.13";

  src = fetchFromGitHub {
    owner = "wustho";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1qsqYlqGlCRhl7HINrcTDt5bGlb7g5PmaERylT+UvEg=";
  };

  meta = with lib; {
    description = "CLI Epub Reader";
    homepage = "https://github.com/wustho/epr";
    license = licenses.mit;
    maintainers = [ maintainers.Br1ght0ne ];
    platforms = platforms.all;
  };
}
