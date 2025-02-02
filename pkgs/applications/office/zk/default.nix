{ lib, fetchFromGitHub, buildGoModule, icu }:

buildGoModule rec {
  pname = "zk";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "zk-org";
    repo = "zk";
    rev = "v${version}";
    sha256 = "sha256-PbF2k7b03Oo3fIWIN4BHUZJ625HUeX+htT9FTINowIs=";
  };

  vendorHash = "sha256-UZsJa5hmMQwe9lhrp4ey8GGTkWUF8xJW+LPWMR0qfoo=";

  doCheck = false;

  CGO_ENABLED = 1;

  ldflags = [ "-s" "-w" "-X=main.Build=${version}" ];

  tags = [ "fts5" ];

  meta = with lib; {
    maintainers = with maintainers; [ pinpox ];
    license = licenses.gpl3;
    description = "Zettelkasten plain text note-taking assistant";
    homepage = "https://github.com/mickael-menu/zk";
    mainProgram = "zk";
  };
}
