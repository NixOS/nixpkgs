{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-d2";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "danieleades";
    repo = "mdbook-d2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+pwPJjjXNre5PduNT8oowP1K4CIT8egA5RxBpp2FmVs=";
  };

  cargoHash = "sha256-uEHg404q3mYqQVYBds9oExXe+xxzrfM9duvQ8BzCXUc=";
  doCheck = false;

  meta = {
    description = "D2 diagram generator plugin for MdBook";
    mainProgram = "mdbook-d2";
    homepage = "https://github.com/danieleades/mdbook-d2";
    changelog = "https://github.com/danieleades/mdbook-d2/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
