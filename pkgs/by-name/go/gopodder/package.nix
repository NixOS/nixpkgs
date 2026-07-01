{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gopodder";
  version = "1.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cbrgm";
    repo = "gopodder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o/iQnr8WLArecRyMttCluuEYwKirKsOJyj5a7tdulVo=";
  };

  vendorHash = "sha256-iG2IUfBVLQ7P0W4HOiGShVyD4mGUQ0dfGjG4XIYVtWU=";

  meta = {
    description = "A self-hostable podcast synchronization server compatible with the gPodder API";
    homepage = "https://github.com/cbrgm/gopodder";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nielmin ];
    mainProgram = "gopodder";
  };
})
