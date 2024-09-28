{ lib, buildPythonApplication, fetchFromGitHub, pyxdg, pytest, pytest-mock }:

buildPythonApplication rec {
  pname   = "pass-git-helper";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner  = "languitar";
    repo   = "pass-git-helper";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-DLH3l4wYfBlrc49swLgyHeZXebJ5JSzU7cHjD7Hmw0g=";
  };

  propagatedBuildInputs = [ pyxdg ];
  nativeCheckInputs = [ pytest pytest-mock ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://github.com/languitar/pass-git-helper";
    description = "Git credential helper interfacing with pass, the standard unix password manager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hmenke vanzef ];
    mainProgram = "pass-git-helper";
  };
}
