{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mx-takeover";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "musana";
    repo = "mx-takeover";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yDQd2FEVFFsUu3wKxp26VDhGjnuXmAtxpWoKjV6ZrHA=";
  };

  vendorHash = "sha256-mJ8pVsgRM6lhEa8jtCxFhavkf7XFlBqEN9l1r0/GTvM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to work with DNS MX records";
    homepage = "https://github.com/musana/mx-takeover";
    changelog = "https://github.com/musana/mx-takeover/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mx-takeover";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
