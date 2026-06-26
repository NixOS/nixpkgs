{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gogup";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h7hozN4ggDqEqu2KlQpBEttT7j8JKW+4J4NyM+ftK2M=";
  };

  vendorHash = "sha256-GbeyuZNpT3wqy52sk0B/9wrab906/E4ds06vQ5tHK7c=";
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
