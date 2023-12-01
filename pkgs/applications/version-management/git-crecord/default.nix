{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "git-crecord";
  version = "20220324.0";

  src = fetchFromGitHub {
    owner = "andrewshadura";
    repo = "git-crecord";
    rev = version;
    sha256 = "sha256-LWO9vteTIe54zTDWyRotLKIIi5SaGD0c9s7B5aBHm0s=";
  };

  propagatedBuildInputs = with python3.pkgs; [ docutils ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/andrewshadura/git-crecord";
    description = "Git subcommand to interactively select changes to commit or stage";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny ];
    mainProgram = "git-crecord";
  };
}
