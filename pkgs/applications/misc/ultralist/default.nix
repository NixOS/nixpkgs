{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ultralist";
  version = "v0.8.1";

  src = fetchFromGitHub {
    owner = "ultralist";
    repo = "ultralist";
    rev = version;
    sha256 = "0dazfymby5xm4482p9cyj23djmkz5q7g79cqm2d85mczvz7vks8p";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Simple GTD-style todo list for the command line";
    homepage = "https://ultralist.io";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
