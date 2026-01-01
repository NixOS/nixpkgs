{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "okolors";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Ivordir";
    repo = "Okolors";
    rev = "v${version}";
    hash = "sha256-U7rLynXZGHCeZjaXoXx2IRDgUFv7zOKfb4BPgDROzBc=";
  };

  cargoHash = "sha256-3wZeRPG2VrpPlqRVmkrMskqzM6NGZoSGbgGBTJzKCgQ=";

<<<<<<< HEAD
  meta = {
    description = "Generate a color palette from an image using k-means clustering in the Oklab color space";
    homepage = "https://github.com/Ivordir/Okolors";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ laurent-f1z1 ];
=======
  meta = with lib; {
    description = "Generate a color palette from an image using k-means clustering in the Oklab color space";
    homepage = "https://github.com/Ivordir/Okolors";
    license = licenses.mit;
    maintainers = with maintainers; [ laurent-f1z1 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "okolors";
  };
}
