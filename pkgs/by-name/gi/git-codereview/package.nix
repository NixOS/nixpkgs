{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "git-codereview";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y15K8j9bqBFbRkYJ2pdfKobpuTglWcm+QDkoTklzWa8=";
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
