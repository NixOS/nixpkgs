{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    hash = "sha256-DQdm6911SNzVxUXpZ4mMumjonThhhEJnM/3GjbCjyuY=";
  };

  cargoHash = "sha256-JhrELBMGVtxJjyfPGcM6v8h1XJjdD+vOsYNfZ86Ras0=";

<<<<<<< HEAD
  meta = {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ zimbatm ];
=======
  meta = with lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mdsh";
  };
}
