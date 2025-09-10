{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bump";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = "bump";
    rev = "v${version}";
    sha256 = "sha256-OD/ZAVLhezhmFSaWyka5kKwEU5FXH3KuzS91eAteR8Y=";
  };

  vendorHash = "sha256-mEeuTyNjyuCdRlvJkMPVSplbNL9KXPgX+F1FNdKTvQU=";

  doCheck = false;

  ldflags = [
    "-X main.buildVersion=${version}"
    "-X main.buildCommit=${version}"
    "-X main.buildDate=1970-01-01"
  ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/mroth/bump";
    description = "CLI tool to draft a GitHub Release for the next semantic version";
    mainProgram = "bump";
    maintainers = with maintainers; [ doronbehar ];
  };
}
