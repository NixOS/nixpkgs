{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "git-crecord";
  version = "20201025.0";

  src = fetchFromGitHub {
    owner = "andrewshadura";
    repo = "git-crecord";
    rev = version;
    sha256 = "1rkdmy2d2vsx22fx97nd9afh0g5lq4pns7rdxyl711apq1bhiihn";
  };

  propagatedBuildInputs = with python3.pkgs; [ docutils ];

  # has no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/andrewshadura/git-crecord";
    description = "Git subcommand to interactively select changes to commit or stage";
    license = lib.licenses.gpl2Plus;
  };
}
