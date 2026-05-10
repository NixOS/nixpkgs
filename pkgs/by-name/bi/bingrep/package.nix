{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bingrep";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = "bingrep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1GSAYhxFg5nXR8+vWBN10JLV7qUIxT1hYNXdnpE5Uag=";
  };

  cargoHash = "sha256-llyItFYNnvWjPYoTrY8oS4z8tU9IuKYCfvHSURDKNDk=";

  meta = {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    mainProgram = "bingrep";
    homepage = "https://github.com/m4b/bingrep";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
