{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "git-credential-oauth";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "hickford";
    repo = "git-credential-oauth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M4SsqF5RE2OZv7Ehf5o79lyeNmNlkiYDPyz2G6HYC88=";
  };

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-ActdfhT4SOWFjXz9XXx1AAnfRQbdTeID79dI8L+WuIc=";

  postInstall = ''
    installManPage $src/git-credential-oauth.1
  '';

  meta = {
    description = "Git credential helper that securely authenticates to GitHub, GitLab and BitBucket using OAuth";
    homepage = "https://github.com/hickford/git-credential-oauth";
    changelog = "https://github.com/hickford/git-credential-oauth/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "git-credential-oauth";
  };
})
