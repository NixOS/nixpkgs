{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gogup";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3wOhKJdIrTBIbiNJGm2LjgV2ocxIznZXXoh5mHthlvU=";
  };

  vendorHash = "sha256-L5dVJrso+A5yjeSW8VQkxkgZ2lhrjAR1Wl/Z6cLUP8Y=";
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
