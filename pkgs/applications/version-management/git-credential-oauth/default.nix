{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-credential-oauth";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "hickford";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FNOGzv0oAPpAPS8V8I+wowKY5uZhfWm6m8obiAay3AE=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-oHusgU5SMkFDY2dhFRdDonyYkyOBGOp+zqx2nFmOWXk=";

  meta = {
    description = "Git credential helper that securely authenticates to GitHub, GitLab and BitBucket using OAuth";
    homepage = "https://github.com/hickford/git-credential-oauth";
    changelog = "https://github.com/hickford/git-credential-oauth/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shyim ];
  };
}
