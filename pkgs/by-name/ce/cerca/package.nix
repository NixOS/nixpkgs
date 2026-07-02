{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cerca";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "cblgh";
    repo = "cerca";
    tag = "v${version}";
    hash = "sha256-T7hlvV3VTskBJx8szT55ekAFd/gCqAUDaKyX3YCfYj4=";
  };

  vendorHash = "sha256-iIZMYIwIgnFvraowh2k8MUTl7L4zhgcm+UojlimpCTk=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Lean forum software";
    homepage = "https://github.com/cblgh/cerca";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dansbandit ];
    mainProgram = "cerca";
  };
}
