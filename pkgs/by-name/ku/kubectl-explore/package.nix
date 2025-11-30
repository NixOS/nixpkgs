{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-explore";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "keisku";
    repo = "kubectl-explore";
    rev = "v${version}";
    hash = "sha256-URpoIK+5MgBvCtXyZrqwU7cVubCICkAsmfS9w/8Jgks=";
  };

  vendorHash = "sha256-TgC8IgB9E83FBP9qrgcqPesnOyOTA5u3AsXn32kaMnU=";
  doCheck = false;

  meta = {
    description = "Better kubectl explain with the fuzzy finder";
    mainProgram = "kubectl-explore";
    homepage = "https://github.com/keisku/kubectl-explore";
    changelog = "https://github.com/keisku/kubectl-explore/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.koralowiec ];
  };
}
