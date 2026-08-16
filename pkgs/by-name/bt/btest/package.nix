{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "btest";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "manawenuz";
    repo = "btest-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bS70knj5xUMj0zCoKUJLJDXMPOErH+yoyISlhbyhFIU=";
  };

  cargoHash = "sha256-ydHr+4yKCzWbznwF6oWjn8S0dTkJqbV01j4p3ksT+60=";

  nativeBuildInputs = [ pkg-config ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  buildInputs = [
    openssl
    sqlite
  ];

  # Tests require network features
  doCheck = false;

  doInstallCheck = true;

  meta = {
    description = "Bandwidth Test server and client";
    homepage = "https://github.com/manawenuz/btest-rs";
    changelog = "https://github.com/manawenuz/btest-rs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "btest";
  };
})
