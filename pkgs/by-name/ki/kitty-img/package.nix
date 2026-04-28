{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kitty-img";
  version = "1.1.1";

  src = fetchFromCodeberg {
    owner = "sashanoraa";
    repo = "kitty-img";
    rev = finalAttrs.version;
    hash = "sha256-r5gt5ESQ/2Z//k6rZtPSp1dnQOYvB6+7T7LUcSryrHY=";
  };

  cargoHash = "sha256-S/f2Q9SpPuAJLr8QkdWjRGwcuE64AhXJMcXMvwAMIUw=";

  meta = {
    description = "Print images inline in kitty";
    homepage = "https://codeberg.org/sashanoraa/kitty-img";
    changelog = "https://codeberg.org/sashanoraa/kitty-img/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ gaykitty ];
    mainProgram = "kitty-img";
  };
})
