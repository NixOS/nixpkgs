{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cerca";
  version = "unstable-2025-05-06";

  src = fetchFromGitHub {
    owner = "cblgh";
    repo = "cerca";
    rev = "95559fe40e8f52fc586e93cb751e1d8892c2591b";
    hash = "sha256-wx0fsP39zr4Z6c2plGLxLAFXeA8P67wI0YJ/eiWRUTg=";
  };

  vendorHash = "sha256-3/StcjgvkXuUXHnBcj/C9hUDF8EVRTJ5IXyuGlupwHc=";

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
