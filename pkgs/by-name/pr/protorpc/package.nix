{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protorpc";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "chai2010";
    repo = "protorpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yu4aSWM0TNnGGLAA6NApMekHMi6e+McGRndi8ptdXfY=";
  };

  vendorHash = "sha256-qGFPUNomcFHRBX33WWdYaAY7196RljwFKuS+EZhKKz8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Google Protocol Protobufs RPC for Go";
    homepage = "https://github.com/chai2010/protorpc";
    changelog = "https://github.com/chai2010/protorpc/blob/${finalAttrs.src.rev}/changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
