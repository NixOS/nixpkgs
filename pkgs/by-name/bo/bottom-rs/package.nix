{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "bottom-rs";
  version = "1.2.0";

  src = fetchCrate {
    inherit version;
    crateName = "bottomify";
    hash = "sha256-R1zj+TFXoolonIFa1zJDd7CdrORfzAPlxJoJVYe9xdc=";
  };

  cargoHash = "sha256-ULMW/1kvq5GeMUMUTQprwcXwnRMDCbow8P6jNwSXHQ8=";

<<<<<<< HEAD
  meta = {
    description = "Fantastic (maybe) CLI for translating between bottom and human-readable text";
    homepage = "https://github.com/bottom-software-foundation/bottom-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ winter ];
=======
  meta = with lib; {
    description = "Fantastic (maybe) CLI for translating between bottom and human-readable text";
    homepage = "https://github.com/bottom-software-foundation/bottom-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ winter ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "bottomify";
  };
}
