{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cariddi";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+nVZmifJvsNbYJ0TYTSQfYB/B0NJaU3wPn/e/2A3j60=";
  };

  vendorHash = "sha256-/xnnkzoS1+fow5audoa4SllSzGMwrxvbjCjCHzOguYU=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    changelog = "https://github.com/edoardottt/cariddi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cariddi";
  };
})
