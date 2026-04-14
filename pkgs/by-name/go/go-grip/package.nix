{
  buildGoModule,
  fetchFromGitHub,
  lib,
  gitUpdater,
}:
buildGoModule (finalAttrs: {
  pname = "go-grip";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "chrishrb";
    repo = "go-grip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HwD/pdWEEU+Hoo4HUJeK8y40jp1byNhw/TSpa5SNRak=";
  };

  vendorHash = "sha256-QsLiCsFY6nI85jsEZtAgmObEKpBSZWhzZk+TlukM8JU=";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Preview Markdown files locally before committing them";
    homepage = "https://github.com/chrishrb/go-grip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "go-grip";
  };
})
