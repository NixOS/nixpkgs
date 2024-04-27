{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "git-credential-oauth";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "hickford";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dGn1I47/S6DYXva5zjvcQnB+I4Ex354xMmZ/3OkpjMw=";
  };

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-nbwrVihcH+ARLHylsjogsv3LVP+0+YtQ+7cozB7pAWo=";

  postInstall = ''
    installManPage $src/git-credential-oauth.1
  '';

  meta = {
    description = "Git credential helper that securely authenticates to GitHub, GitLab and BitBucket using OAuth";
    homepage = "https://github.com/hickford/git-credential-oauth";
    changelog = "https://github.com/hickford/git-credential-oauth/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shyim ];
    mainProgram = "git-credential-oauth";
  };
}
