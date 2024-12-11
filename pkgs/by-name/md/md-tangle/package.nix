{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "md-tangle";
  version = "1.3.1";

  # By some strange reason, fetchPypi fails miserably
  src = fetchFromGitHub {
    owner = "joakimmj";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cUME2AHK/Fva+1TSTE6hNu0SE/V1FOwcSxWF0+iZhS4=";
  };

  # Pure Python application, uses only standard modules and comes without
  # testing suite
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/joakimmj/md-tangle/";
    description = "Generates (\"tangles\") source code from Markdown documents";
    mainProgram = "md-tangle";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
