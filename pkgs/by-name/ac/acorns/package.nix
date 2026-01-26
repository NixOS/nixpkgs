{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "acorns";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "redhat-documentation";
    repo = "acorns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JsqwTj6pWEALMSzl3cBGCNRkGlFXmZ3CMy4Z33Zv43k=";
  };

  cargoHash = "sha256-mXnFwn/j+l4CppbQ78rmJJF/qLL2bx3e6g4yVr5LACs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Generate an AsciiDoc release notes document from tracking tickets";
    homepage = "https://redhat-documentation.github.io/acorns/";
    downloadPage = "https://github.com/redhat-documentation/acorns";
    changelog = "https://github.com/redhat-documentation/acorns/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "acorns";
  };
})
