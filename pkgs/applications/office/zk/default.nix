{ lib, fetchFromGitHub, buildGoModule, icu }:

buildGoModule rec {
  pname = "zk";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "mickael-menu";
    repo = "zk";
    rev = "v${version}";
    sha256 = "sha256-Q1MU2NGeVjBNnwoAWuoO18xhtt+bdQ2ms37tHnW+R94=";
  };

  vendorHash = "sha256-11GzI3aEhKKTiULoWq9uIc66E3YCrW/HJQUYXRhCaek=";

  doCheck = false;

  CGO_ENABLED = 1;

  ldflags = [ "-s" "-w" "-X=main.Build=${version}" ];

  tags = [ "fts5" ];

  meta = with lib; {
    maintainers = with maintainers; [ pinpox ];
    license = licenses.gpl3;
    description = "A zettelkasten plain text note-taking assistant";
    homepage = "https://github.com/mickael-menu/zk";
  };
}
