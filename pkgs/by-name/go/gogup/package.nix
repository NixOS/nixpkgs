{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gogup";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y2DjbngL0Xp8oleTfRK7SwcPkE6QmpdzZdwI//IL0Qg=";
  };

  vendorHash = "sha256-u5fP8nBwtoSAVNI6NBlPpMjCc27oZ9/By6wMxHudgR4=";
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
