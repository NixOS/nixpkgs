{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "git-chglog";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "git-chglog";
    repo = "git-chglog";
    rev = "v${version}";
    sha256 = "sha256-VB3JYXz50B/SkA/q1iET7p5uhArrF8JyhAWhcxLVsg8=";
  };

  vendorHash = "sha256-/5s9Dvce0JWu8DaUlrtnkN6N5esEmkFvOgq0tVLZGnM=";

  ldflags = [ "-s" "-w" "-X=main.Version=v${version}" ];

  subPackages = [ "cmd/git-chglog" ];

  meta = with lib; {
    description = "CHANGELOG generator implemented in Go (Golang)";
    homepage = "https://github.com/git-chglog/git-chglog";
    license = licenses.mit;
    maintainers = with maintainers; [ ldenefle ];
  };
}
