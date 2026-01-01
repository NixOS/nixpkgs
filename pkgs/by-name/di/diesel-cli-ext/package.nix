{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "diesel-cli-ext";
  version = "0.3.13";

  src = fetchCrate {
    pname = "diesel_cli_ext";
    inherit version;
    hash = "sha256-5AIzMxEcxL/vYWx3D/meA///Zo+1210HUMEE4dFBhkc=";
  };

  cargoHash = "sha256-AvoyJPh59fZPDcOtIZ4UFUgW83szBC3HOOlkxA3VFgE=";

<<<<<<< HEAD
  meta = {
    description = "Provides different tools for projects using the diesel_cli";
    homepage = "https://crates.io/crates/diesel_cli_ext";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Provides different tools for projects using the diesel_cli";
    homepage = "https://crates.io/crates/diesel_cli_ext";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      mit
    ];
    mainProgram = "diesel_ext";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ siph ];
=======
    maintainers = with maintainers; [ siph ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
