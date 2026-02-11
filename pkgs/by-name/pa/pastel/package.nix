{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pastel";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "pastel";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ISzZZNh9X91vBbVOpYXnYpO3ztGgIhMJTZmoY2T0FRw=";
  };

  cargoHash = "sha256-r0QiooMrTqFaXq2Y9wVW45zjtHT7qQ6XTWPRhlLpVQ8=";

  meta = {
    description = "Command-line tool to generate, analyze, convert and manipulate colors";
    homepage = "https://github.com/sharkdp/pastel";
    changelog = "https://github.com/sharkdp/pastel/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    mainProgram = "pastel";
  };
})
