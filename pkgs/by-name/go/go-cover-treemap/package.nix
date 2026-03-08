{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-cover-treemap";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "nikolaydubina";
    repo = "go-cover-treemap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MSkPot8uYcr8pxsIkJh2FThVK9xpzkN9Y69KeiQnQlA=";
  };

  vendorHash = "sha256-k/k+EGkuBnZFHrcWxnzLG8efWgb2i35Agf/sWbgTc4g=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Go code coverage to SVG treemap";
    homepage = "https://github.com/nikolaydubina/go-cover-treemap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "go-cover-treemap";
  };
})
