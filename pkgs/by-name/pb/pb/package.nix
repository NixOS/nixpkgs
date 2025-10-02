{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pb";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "pb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OXxLHi7v/xJZVvxHZvJ0eH4MYrlLFxDAMT9CVG2mWTM=";
  };

  vendorHash = "sha256-N6m0qvj65Ls3yQmVGw0AklsO1zs1KHdi/Y6FZRghnCs=";

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
