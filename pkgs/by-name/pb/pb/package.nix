{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pb";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "pb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q389FVNVxIoDr65imIg5gjn8/CnKl437a04ojm9uyrA=";
  };

  vendorHash = "sha256-hEVoz8EgC2hAkiC0LNZ+h/Hy7toVxWvv2gchymfpMK8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  tags = [ "kqueue" ];

  # Version test has been removed since it requires network access.

  meta = {
    homepage = "https://github.com/parseablehq/pb";
    changelog = "https://github.com/parseablehq/pb/releases/tag/v${finalAttrs.version}";
    description = "CLI client for Parseable server";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "pb";
  };
})
