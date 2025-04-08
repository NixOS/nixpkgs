{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  risor,
}:

buildGoModule rec {
  pname = "risor";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${version}";
    hash = "sha256-QtYqepNH+c0WDGKTLtMz/VUz0oDOgCbwe4D9I4wal5s=";
  };

  proxyVendor = true;
  vendorHash = "sha256-JrBuHA+u5bI2kcbWaY6/894kh5Xdix0ov6nN5r9rJRE=";

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
