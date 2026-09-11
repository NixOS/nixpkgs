{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pastel";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "pastel";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0NrvZ9rOc3li430uYJjP2IkMeofeq4NkC7GvsYZeB2g=";
  };

  cargoHash = "sha256-FPaMBxrSrmHbq5b4Q9QxElD+jAhn22gvKP55QWwZ/mo=";

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
