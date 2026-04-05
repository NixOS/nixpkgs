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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "manawenuz";
    repo = "btest-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ltePF8HX46FDbdyq30u19FNVpIwPxhOo8AgNvKRzKHE=";
  };

  cargoHash = "sha256-8AO7eTzZMzvNWcls3VXP0kPun/D5gsA1ih0FOqZ57R0=";

  postPatch = ''
    # https://github.com/manawenuz/btest-rs/pull/1
    substituteInPlace Cargo.toml \
      --replace-fail "0.6.0" "${finalAttrs.version}"
  '';

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
    changelog = "https://github.com/manawenuz/btest-rs/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "btest";
  };
})
