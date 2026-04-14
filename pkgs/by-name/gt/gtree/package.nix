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
  version = "1.13.5";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2OhXb6ivje7Li/sUO+YHfZPRBKoQnUhNbhbFtqlyjyM=";
  };

  vendorHash = "sha256-UTJQvoiqdF1q4VRUfAx7a7V5UyH+zjwDM5YU7cqVDKE=";

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
