{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "git-codereview";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ls8dfAeC1rku5nOLe8zv7strLm7Z/QPKuJ6MguH3V8I=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [ git ];

  meta = {
    description = "Manage the code review process for Git changes using a Gerrit server";
    homepage = "https://golang.org/x/review/git-codereview";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.edef ];
    mainProgram = "git-codereview";
  };
})
