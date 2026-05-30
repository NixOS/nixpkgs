{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  testers,
  avml,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avml";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "avml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d8H+UPCH3yyBNndlGzamgaPlhmvP4rcUSAywx8vYky0=";
  };

  cargoHash = "sha256-LxoyvjFVn69s9Wf8pF+9wBgOV4fJ/th6GPzLW6hbz0E=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.tests.version = testers.testVersion { package = avml; };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Portable volatile memory acquisition tool for Linux";
    homepage = "https://github.com/microsoft/avml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lesuisse ];
    platforms = lib.platforms.linux;
    mainProgram = "avml";
  };
})
