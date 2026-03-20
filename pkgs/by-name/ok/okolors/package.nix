{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "okolors";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Ivordir";
    repo = "Okolors";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RSkZUkwCn9uvvT2dIqM2Q4+mRqjUegVuXCms5DBugbk=";
  };

  cargoHash = "sha256-ceFyFbNmC7PoleTejymQw9Ii9rxx2qJmFifNAQjLVUM=";

  meta = {
    description = "Generate a color palette from an image using k-means clustering in the Oklab color space";
    homepage = "https://github.com/Ivordir/Okolors";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "okolors";
  };
})
