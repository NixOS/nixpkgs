{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "go-grip";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "chrishrb";
    repo = "go-grip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xi9h9sykuhL2Wh08zhwE1ZT1ncd6GCmQF6uuLU0vpCI=";
  };

  vendorHash = "sha256-QsLiCsFY6nI85jsEZtAgmObEKpBSZWhzZk+TlukM8JU=";

  meta = {
    description = "Preview Markdown files locally before committing them";
    homepage = "https://github.com/chrishrb/go-grip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "go-grip";
  };
})
