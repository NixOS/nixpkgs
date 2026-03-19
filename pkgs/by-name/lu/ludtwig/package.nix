{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ludtwig";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = "ludtwig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V0T+yinjTVkAXA604bfEGDzpCd0saNt5S71XFaFqdxg=";
  };

  checkType = "debug";

  cargoHash = "sha256-qR7V7fvWsDsLDRwfvM5UV7iKLGxE722eXvYrZTBtGpQ=";

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
