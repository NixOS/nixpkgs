{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-explore";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "keisku";
    repo = "kubectl-explore";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sWVNDXbGaqVEWkHnZbHy9W4lFH8N/aULIzBJLGSXCjs=";
  };

  vendorHash = "sha256-TgC8IgB9E83FBP9qrgcqPesnOyOTA5u3AsXn32kaMnU=";
  doCheck = false;

  meta = {
    description = "Better kubectl explain with the fuzzy finder";
    mainProgram = "kubectl-explore";
    homepage = "https://github.com/keisku/kubectl-explore";
    changelog = "https://github.com/keisku/kubectl-explore/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.koralowiec ];
  };
})
