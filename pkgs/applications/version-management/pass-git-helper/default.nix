{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  pyxdg,
  pytest,
  pytest-mock,
}:

buildPythonApplication rec {
  pname = "pass-git-helper";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "languitar";
    repo = "pass-git-helper";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-IpMaCG6kPNrWtcl10Lh7A3PyIF4Mk0t2wLYON+zMLsE=";
  };

  propagatedBuildInputs = [ pyxdg ];
  nativeCheckInputs = [
    pytest
    pytest-mock
  ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://github.com/languitar/pass-git-helper";
    description = "A git credential helper interfacing with pass, the standard unix password manager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      hmenke
      vanzef
    ];
    mainProgram = "pass-git-helper";
  };
}
