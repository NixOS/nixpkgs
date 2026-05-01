{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "md-tangle";
  version = "2.0.0";
  pyproject = true;

  # By some strange reason, fetchPypi fails miserably
  src = fetchFromGitHub {
    owner = "joakimmj";
    repo = "md-tangle";
    tag = "v${version}";
    hash = "sha256-CvSdak1QajOgApM+G/o0F6dsppmnBcEztzFRlYxTNig=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  # Pure Python application, uses only standard modules and comes without
  # testing suite
  doCheck = false;

  pythonImportsCheck = [ "md_tangle" ];

  meta = {
    homepage = "https://github.com/joakimmj/md-tangle/";
    description = "Generates (\"tangles\") source code from Markdown documents";
    mainProgram = "md-tangle";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
