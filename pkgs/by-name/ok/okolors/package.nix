{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "okolors";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "IanManske";
    repo = "Okolors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSkZUkwCn9uvvT2dIqM2Q4+mRqjUegVuXCms5DBugbk=";
  };

  cargoHash = "sha256-ceFyFbNmC7PoleTejymQw9Ii9rxx2qJmFifNAQjLVUM=";

  passthru = {
    updateScript = nix-update-script { };
  };

  __structuredAttrs = true;

  meta = {
    description = "Generate a color palette from an image using k-means clustering in the Oklab color space";
    homepage = "https://github.com/IanManske/Okolors";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
    changelog = "https://github.com/IanManske/Okolors/releases/tag/v${finalAttrs.version}";
    mainProgram = "okolors";
  };
})
