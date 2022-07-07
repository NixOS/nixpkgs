{ lib, buildPythonApplication, fetchFromGitHub, pyxdg, pytest, pytest-mock }:

buildPythonApplication rec {
  pname   = "pass-git-helper";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner  = "languitar";
    repo   = "pass-git-helper";
    rev    = "v${version}";
    sha256 = "sha256-An9JKnS/Uor7iZ+lbBGR3eOkxOgV+SjnCWN/QmqFI/I=";
  };

  propagatedBuildInputs = [ pyxdg ];
  checkInputs = [ pytest pytest-mock ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://github.com/languitar/pass-git-helper";
    description = "A git credential helper interfacing with pass, the standard unix password manager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hmenke vanzef ];
  };
}
