{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cariddi";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "cariddi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ULeG+TmpRbHT+GsEuEsSSCzlOwRzDzUZmPZNN7KZdrA=";
  };

  vendorHash = "sha256-DgyDRMDYBC4GVuffJCrNpoDsqtpZ/LH++q5zXdkC1YE=";

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
