{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  risor,
}:

buildGoModule (finalAttrs: {
  pname = "risor";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Vw0fslKtBGdL6BjzNYzGRneQ+jtNDvAymlUxNa0lKZ8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-yVvryqPB35Jc3MXIJyRlFhAHU8H8PmSs60EO/JABHDs=";

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
    homepage = "https://github.com/risor-io/risor";
    changelog = "https://github.com/risor-io/risor/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
