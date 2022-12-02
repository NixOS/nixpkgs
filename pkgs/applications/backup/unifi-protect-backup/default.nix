{ fetchFromGitHub, python3, lib }:

python3.pkgs.buildPythonApplication rec {
  pname = "unifi-protect-backup";
  version = "0.7.4";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ep1cman";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4Kpz89yqKmxHmnaPYpvJ2hx46yfcaCYjOioyya+38vE=";
  };

  preBuild = ''
    sed -i 's_click = "8.0.1"_click = "^8"_' pyproject.toml
    sed -i 's_pyunifiprotect = .*_pyunifiprotect = "*"_' pyproject.toml
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiocron
    click
    pyunifiprotect
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python tool to backup unifi event clips in realtime";
    homepage = "https://github.com/ep1cman/unifi-protect-backup";
    maintainers = with maintainers; [ ajs124 ];
    license = licenses.mit;
  };
}
