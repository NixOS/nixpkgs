{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gogup";
  version = "0.28.2";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ETUCMDF0dU2p/nKC07T2rVtDvKRSatqijRu4PanbxXc=";
  };

  vendorHash = "sha256-Dm9g2SA5qYYcmnQ1xApVVvWG7+CaQs5blv7qJOANL8Q=";
  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/nao1215/gup/internal/cmdinfo.Version=v${finalAttrs.version}"
  ];

  meta = {
    description = "Update binaries installed by 'go install' with goroutines";
    changelog = "https://github.com/nao1215/gup/blob/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/nao1215/gup";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "gup";
  };
})
