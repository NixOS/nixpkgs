{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "git-chglog";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "git-chglog";
    repo = "git-chglog";
    rev = "v${version}";
    sha256 = "sha256-BiTnPCgymfpPxuy0i8u7JbpbEBeaSIJaikjwsPSA3qc=";
  };

  vendorSha256 = "sha256-jIq+oacyT71m78iMZwWOBsBVAY/WxgyH9zRr8GiMGTU=";

  ldflags = [ "-s" "-w" "-X=main.Version=v${version}" ];

  subPackages = [ "cmd/git-chglog" ];

  meta = with lib; {
    description = "CHANGELOG generator implemented in Go (Golang)";
    homepage = "https://github.com/git-chglog/git-chglog";
    license = licenses.mit;
    maintainers = with maintainers; [ ldenefle ];
  };
}
