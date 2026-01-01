{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "md-tangle";
  version = "1.4.4";
  pyproject = true;

  # By some strange reason, fetchPypi fails miserably
  src = fetchFromGitHub {
    owner = "joakimmj";
    repo = "md-tangle";
    tag = "v${version}";
    hash = "sha256-PkOKSsyY8uwS4mhl0lB+KGeUvXfEc7PUDHZapHMYv4c=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  # Pure Python application, uses only standard modules and comes without
  # testing suite
  doCheck = false;

  pythonImportsCheck = [ "md_tangle" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/joakimmj/md-tangle/";
    description = "Generates (\"tangles\") source code from Markdown documents";
    mainProgram = "md-tangle";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/joakimmj/md-tangle/";
    description = "Generates (\"tangles\") source code from Markdown documents";
    mainProgram = "md-tangle";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
