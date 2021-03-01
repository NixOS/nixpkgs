{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-chglog";
  version = "0.9.1";

  goPackagePath = "github.com/git-chglog/git-chglog";

  src = fetchFromGitHub {
    owner = "git-chglog";
    repo = "git-chglog";
    rev = version;
    sha256 = "08x7w1jlvxxvwnz6pvkjmfd3nqayd8n15r9jbqi2amrp31z0gq0p";
  };

  meta = with lib; {
    description = "CHANGELOG generator implemented in Go (Golang)";
    license = licenses.mit;
    maintainers = with maintainers; [ ldenefle ];
  };
}

