{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  git-sizer,
}:

buildGoModule (finalAttrs: {
  pname = "git-sizer";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "git-sizer";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bY7Es7aE/UsiTrZkR6+gCuTukMaLML5l6k8DWWUnlCc=";
  };

  vendorHash = "sha256-Lt1BFnZaN3sffYzyXL6bRIVp3hoQlQoNxZS9tOXLTus=";

  ldflags = [
    "-s"
    "-w"
    "-X main.BuildVersion=${finalAttrs.version}"
  ];

  doCheck = false;

  passthru.tests.vesion = testers.testVersion {
    package = git-sizer;
  };

  meta = {
    description = "Compute various size metrics for a Git repository";
    homepage = "https://github.com/github/git-sizer";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "git-sizer";
  };
})
