{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  risor,
}:

buildGoModule (finalAttrs: {
  pname = "risor";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "deepnoodle-ai";
    repo = "risor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NAvC0LV+15NUSHTUpPGa45YjMtktOcdS5iC43BHCjDE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-bBudCrm8fwWYUwBrWNE3zvdBlsvXjV+dIb3nZWHl5Mo=";

  subPackages = [
    "cmd/risor"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = risor;
      command = "risor version";
    };
  };

  meta = {
    description = "Fast and flexible scripting for Go developers and DevOps";
    mainProgram = "risor";
    homepage = "https://github.com/deepnoodle-ai/risor";
    changelog = "https://github.com/deepnoodle-ai/risor/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
