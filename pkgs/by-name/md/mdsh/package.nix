{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdsh";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DQdm6911SNzVxUXpZ4mMumjonThhhEJnM/3GjbCjyuY=";
  };

  cargoHash = "sha256-JhrELBMGVtxJjyfPGcM6v8h1XJjdD+vOsYNfZ86Ras0=";

  meta = {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ zimbatm ];
    mainProgram = "mdsh";
  };
})
