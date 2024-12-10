{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "git-credential-oauth";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "hickford";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vs+PRFyvzn25nM6oO4VybXkTr1frmSspA2isSXLJFQo=";
  };

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-muK8UZW+8bhC6K0FvN6B7evTMeZnMeYlrIMJdJprPLM=";

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
