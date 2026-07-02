{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "fanbox-dl";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vXKiShP8RdIT8pRhDkO5K3fBVHQZ9nXv5GAhZaEXj8E=";
  };

  vendorHash = "sha256-uhNitrJeFuFG2XyQrc1JBbExoU6Ln6AFRO2Bgb1+N5M=";

  # pings websites during testing
  doCheck = false;

  meta = {
    description = "Pixiv FANBOX Downloader";
    mainProgram = "fanbox-dl";
    homepage = "https://github.com/hareku/fanbox-dl";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.moni ];
  };
})
