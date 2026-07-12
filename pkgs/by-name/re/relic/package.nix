{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  relic,
}:

buildGoModule (finalAttrs: {
  pname = "relic";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = "relic";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-dXvKbuAJCL+H0Gh0ZF1VvtY+7cgjq7gs8zwtenI3JuI=";
  };

  vendorHash = "sha256-3ERGIZZM8hNbt8kYApcqaL2LJ3V5aloSsmJavX2VSpw=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = relic;
    };
  };

  # Some of the tests use localhost networking. See discussion:
  # https://github.com/NixOS/nixpkgs/pull/374824
  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/sassoftware/relic";
    description = "Service and a tool for adding digital signatures to operating system packages for Linux and Windows";
    mainProgram = "relic";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ strager ];
  };
})
