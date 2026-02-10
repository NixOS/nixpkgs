{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hexdino";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "Luz";
    repo = "hexdino";
    rev = finalAttrs.version;
    hash = "sha256-M1lUm8rJj9c+9MgU7AJvk/ZVuTC1QYPsHRQxCQTc3WI=";
  };

  cargoHash = "sha256-IZhQ80iDO6l1FLAbq2l7QLpjoenkri3wBdQ6Mnz+BOI=";

  meta = {
    description = "Hex editor with vim like keybindings written in Rust";
    homepage = "https://github.com/Luz/hexdino";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.luz ];
    mainProgram = "hexdino";
  };
})
