{ lib, fetchFromGitHub, buildPythonApplication, pytest, git }:

buildPythonApplication rec {
  pname = "mu-repo";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "fabioz";
    repo = pname;
    rev = with lib;
      "mu_repo_" + concatStringsSep "_" (splitVersion version);
    sha256 = "1dxfggzbhiips0ww2s93yba9842ycp0i3x2i8vvcx0vgicv3rv6f";
  };

  checkInputs = [ pytest git ];
  # disable test which assumes it's a git repo
  checkPhase = "py.test mu_repo --ignore=mu_repo/tests/test_checkout.py";

  meta = with lib; {
    description = "Tool to help in dealing with multiple git repositories";
    homepage = "http://fabioz.github.io/mu-repo/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
