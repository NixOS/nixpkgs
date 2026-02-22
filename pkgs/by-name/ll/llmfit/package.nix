{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmfit";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-XmbxJlchBhXrAK8Yjn1dTBxrg+90B9/0HXgEhmZz6+4=";
  };

  cargoHash = "sha256-VTFZ592eZZToj5MeC2mdpugMazWmqyO5VrKLJbweI/E=";

  meta = {
    description = "Find what runs on your hardware";
    homepage = "https://github.com/AlexsJones/llmfit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "llmfit";
  };
})
