{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  gtree,
  nix-update-script,
  testers,
}:
# buildGoModule currently builds with go 1.25.0. This package requires
# version 1.26.0 theirfor needing to be pinned to buildGo126Module until
# it's updated.
buildGo126Module (finalAttrs: {
  pname = "gtree";
  version = "1.14.5";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tGmRVRy+xUq/WEYz7QktR7xuxKFbCWO7LSbAmSAodYw=";
  };

  vendorHash = "sha256-Vd5VKKl79Qu5R7jOYS1CTtQuAis9vWUbpBWnEI7sgpk=";

  subPackages = [
    "cmd/gtree"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.Revision=${finalAttrs.src.tag}"
  ];

  passthru = {
    tests = {
      version = testers.testVersion {
        package = gtree;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Generate directory trees and directories using Markdown or programmatically";
    mainProgram = "gtree";
    homepage = "https://github.com/ddddddO/gtree";
    changelog = "https://github.com/ddddddO/gtree/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hythera ];
  };
})
