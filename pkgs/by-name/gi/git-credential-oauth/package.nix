{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "git-credential-oauth";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "hickford";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9AoIyQ05Y/usG0Tlehn7U8zjBxC1BYNjNVRtgWgzLbo=";
  };

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-g6HT0hmY2RQceSOigH2bVj1jXYhXq95xL0Qak7TMx0o=";

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
