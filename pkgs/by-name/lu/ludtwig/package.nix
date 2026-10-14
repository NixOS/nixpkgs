{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ludtwig";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = "ludtwig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yUnMLEHw7sWLpzCXvHnVFabomf7dUqDApcUkg1KJaNE=";
  };

  checkType = "debug";

  cargoHash = "sha256-FhFYpBSs9onklbeynb5hIJp79HnACDTgoMPoHIAp7jU=";

  meta = {
    description = "Linter / Formatter for Twig template files which respects HTML and your time";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      maltejanz
    ];
    mainProgram = "ludtwig";
  };
})
