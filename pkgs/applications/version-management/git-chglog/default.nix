{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "git-chglog";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "git-chglog";
    repo = "git-chglog";
    rev = "v${version}";
    sha256 = "sha256-rTJn2vUrEnmG2japqCxHv3BR9MpmMfpMLO2FBP6ONbw=";
  };

  vendorHash = "sha256-skhEHpSnxOTZrL8XLlQZL3s224mg8XRINKJnatYCQko=";

  ldflags = [ "-s" "-w" "-X=main.Version=v${version}" ];

  subPackages = [ "cmd/git-chglog" ];

  meta = with lib; {
    description = "CHANGELOG generator implemented in Go (Golang)";
    homepage = "https://github.com/git-chglog/git-chglog";
    license = licenses.mit;
    maintainers = with maintainers; [ ldenefle ];
  };
}
