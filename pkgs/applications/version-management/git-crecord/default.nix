{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "git-crecord";
  version = "20230226.0";

  src = fetchFromGitHub {
    owner = "andrewshadura";
    repo = "git-crecord";
    rev = "refs/tags/${version}";
    sha256 = "sha256-zsrMAD9EU+TvkWfWl9x6WbMXuw7YEz50LxQzSFVkKdQ=";
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
