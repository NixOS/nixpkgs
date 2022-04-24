{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "git-chglog";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "git-chglog";
    repo = "git-chglog";
    rev = "v${version}";
    sha256 = "sha256-UlhJ004ceXpdB/9296cL2sbBYsjV8D+3YS1vmFgnko8=";
  };

  vendorSha256 = "sha256-FLFPcmkrhZ+/UX1xpexsDv3cgC/Ocj4qTFJOX+rmdyQ=";

  ldflags = [ "-s" "-w" "-X=main.Version=v${version}" ];

  subPackages = [ "cmd/git-chglog" ];

  meta = with lib; {
    description = "CHANGELOG generator implemented in Go (Golang)";
    homepage = "https://github.com/git-chglog/git-chglog";
    license = licenses.mit;
    maintainers = with maintainers; [ ldenefle ];
  };
}
