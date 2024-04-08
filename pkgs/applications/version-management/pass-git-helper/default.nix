{ lib, buildPythonApplication, fetchFromGitHub, pyxdg, pytest, pytest-mock }:

buildPythonApplication rec {
  pname   = "pass-git-helper";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner  = "languitar";
    repo   = "pass-git-helper";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-wkayj7SvT3SOM+rol17+8LQJR/YXSC6I+iKbHRUbdZc=";
  };

  propagatedBuildInputs = [ pyxdg ];
  nativeCheckInputs = [ pytest pytest-mock ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://github.com/languitar/pass-git-helper";
    description = "A git credential helper interfacing with pass, the standard unix password manager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hmenke vanzef ];
    mainProgram = "pass-git-helper";
  };
}
