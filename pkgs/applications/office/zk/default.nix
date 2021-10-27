{ lib, fetchFromGitHub, buildGoModule, icu }:

buildGoModule rec {
  pname = "zk";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mickael-menu";
    repo = "zk";
    rev = "v${version}";
    sha256 = "sha256-C3/V4v8lH4F3S51egEw5d51AI0n5xzBQjwhrI64FEGA=";
  };

  vendorSha256 = "sha256-m7QGv8Vx776TsN7QHXtO+yl3U1D573UMZVyg1B4UeIk=";

  doCheck = false;

  buildInputs = [ icu ];

  CGO_ENABLED = 1;

  ldflags = [ "-s" "-w" "-X=main.Build=${version}" ];

  tags = [ "fts5" "icu" ];

  meta = with lib; {
    maintainers = with maintainers; [ pinpox ];
    license = licenses.gpl3;
    description = "A zettelkasten plain text note-taking assistant";
    homepage = "https://github.com/mickael-menu/zk";
  };
}
