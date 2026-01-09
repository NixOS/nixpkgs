{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "git-credential-oauth";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "hickford";
    repo = "git-credential-oauth";
    rev = "v${version}";
    hash = "sha256-QvR09UiLWzonmFPZopXJozMSd58nGW4yVxn/JkAmV3A=";
  };

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-ActdfhT4SOWFjXz9XXx1AAnfRQbdTeID79dI8L+WuIc=";

  postInstall = ''
    installManPage $src/git-credential-oauth.1
  '';

  meta = {
    description = "Git credential helper that securely authenticates to GitHub, GitLab and BitBucket using OAuth";
    homepage = "https://github.com/hickford/git-credential-oauth";
    changelog = "https://github.com/hickford/git-credential-oauth/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "git-credential-oauth";
  };
}
