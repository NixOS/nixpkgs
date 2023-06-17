{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-credential-oauth";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hickford";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f12PgTtfs/S9RI8+QFROkNqccRWeIW1/YkynqvKJc7I=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-9X7ti3NR5MKK0MpiyTOTO+EtdMuu4/TW/diHq9FjSHY=";

  meta = {
    description = "Git credential helper that securely authenticates to GitHub, GitLab and BitBucket using OAuth";
    homepage = "https://github.com/hickford/git-credential-oauth";
    changelog = "https://github.com/hickford/git-credential-oauth/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shyim ];
  };
}
