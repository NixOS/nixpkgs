{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pb";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "pb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JFoMArwAjOr2zyshrC/BDGe3Uit4TBNgA5vHm9CsdEU=";
  };

  vendorHash = "sha256-hEVoz8EgC2hAkiC0LNZ+h/Hy7toVxWvv2gchymfpMK8=";

  ldflags = [
    "-s"
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
