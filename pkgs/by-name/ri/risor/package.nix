{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  risor,
}:

buildGoModule rec {
  pname = "risor";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${version}";
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
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = risor;
      command = "risor version";
    };
  };

  meta = with lib; {
    description = "Fast and flexible scripting for Go developers and DevOps";
    mainProgram = "risor";
    homepage = "https://github.com/risor-io/risor";
    changelog = "https://github.com/risor-io/risor/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
