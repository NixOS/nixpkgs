{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ludtwig";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = "ludtwig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-scPDwfHCNGncYOWH4oKu5xSwu/E3gnL2V9ByOGsGsoY=";
  };

  checkType = "debug";

  cargoHash = "sha256-D2EV6yZWKW1wUDLxms17mH5jnLKxWJZ1AtOLg4C9VA0=";

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
