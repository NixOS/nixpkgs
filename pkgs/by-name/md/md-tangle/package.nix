{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "md-tangle";
  version = "1.4.4";
  format = "setuptools";

  # By some strange reason, fetchPypi fails miserably
  src = fetchFromGitHub {
    owner = "joakimmj";
    repo = "md-tangle";
    tag = "v${version}";
    hash = "sha256-PkOKSsyY8uwS4mhl0lB+KGeUvXfEc7PUDHZapHMYv4c=";
  };

  # Pure Python application, uses only standard modules and comes without
  # testing suite
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/joakimmj/md-tangle/";
    description = "Generates (\"tangles\") source code from Markdown documents";
    mainProgram = "md-tangle";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
