{ lib, stdenv, buildPythonApplication, fetchFromGitHub, pyxdg, pytest }:

buildPythonApplication rec {
  pname   = "pass-git-helper";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner  = "languitar";
    repo   = "pass-git-helper";
    rev    = "v${version}";
    sha256 = "18nvwlp0w4aqj268wly60rnjzqw2d8jl0hbs6bkwp3hpzzz5g6yd";
  };

  propagatedBuildInputs = [ pyxdg ];
  checkInputs = [ pytest ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://github.com/languitar/pass-git-helper";
    description = "A git credential helper interfacing with pass, the standard unix password manager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vanzef ];
  };
}
