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
  version = "1.6.0";

  src = fetchFromCodeberg {
    owner = "wvhulle";
    repo = "nu-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KAWRxzmqHQyIJkmjLWwB6HcmlzIzEjcbYFCrzX7LrN4=";
  };

  cargoHash = "sha256-zZMXmcW1CKHq+BMbcK20Ta/87MoT6y0mCya56GDj8+Q=";

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
