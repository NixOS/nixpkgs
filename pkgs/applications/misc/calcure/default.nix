{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "calcure";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = "calcure";
    rev = "${version}";
    sha256 = "sha256-ciuk41DFQJfg9S/Lwf8qIANDd6DfxW8nchxYXpkQCOE=";
  };

  propagatedBuildInputs = with python3.pkgs; [ holidays ];

  meta = with lib; {
    description = "Calendar and task manager for Linux terminal with minimal and customizable UI";
    homepage = "https://github.com/anufrievroman/calcure";
    license = licenses.mit;
    maintainers = with maintainers; [ taha ];
  };
}
