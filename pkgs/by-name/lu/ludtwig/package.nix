{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ludtwig";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = "ludtwig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-czxfze7irABr5+iGwsJ7wR2kqRwDC6wOFGGxj1SUijw=";
  };

  checkType = "debug";

  cargoHash = "sha256-gSTWma7zZ4K425Tx8VSyEG5IBQnsoK+B2Rmt895b580=";

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
