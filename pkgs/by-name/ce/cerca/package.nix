{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cerca";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "cblgh";
    repo = "cerca";
    tag = "v${version}";
    hash = "sha256-lLN2VCbbX4HnUY5c+YhwZHpVN2w6YoV/5CtbeT3wHjE=";
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
