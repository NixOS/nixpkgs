{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "git-codereview";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yvPAk1i4AeC/kPRsBP5SBTohBZzLWmQWoN2UGTUp3QQ=";
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
