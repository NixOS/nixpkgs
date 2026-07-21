{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
  stdenvNoCC,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu-lint";
  version = "1.2.1";

  src = fetchFromCodeberg {
    owner = "wvhulle";
    repo = "nu-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5YR1Cn9/psNswLVYtDZGmvoP9AwBANa0sPHN4eqcRhQ=";
  };

  cargoHash = "sha256-FA9C7Li4wtXvI8+jDTmdFjqsop6cvGNPByRpOfvQPzw=";

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    # Avoids "couldn't find any valid shared libraries matching: ['libclang.dylib']" error on darwin in sandbox mode.
    rustPlatform.bindgenHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  # NOTE: Disabled for version 0.1.1 outputs "0.1.0" when run `nu-lint --version` is run
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linter for the Nu shell scripting language";
    homepage = "https://codeberg.org/wvhulle/nu-lint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    platforms = lib.platforms.all;
    mainProgram = "nu-lint";
  };
})
