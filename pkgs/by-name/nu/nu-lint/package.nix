{
  lib,
  fetchFromGitea,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
  stdenvNoCC,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu-lint";
  version = "0.0.137";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wvhulle";
    repo = "nu-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jnhzuiK25PxKECkL5bz3DFtgsMYxoVsfbDjg1HljkMA=";
  };

  cargoHash = "sha256-B94xU/YfJZKT/TgMhigTGQBk2cI0whebDAe9dNNNVnw=";

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    # Avoids "couldn't find any valid shared libraries matching: ['libclang.dylib']" error on darwin in sandbox mode.
    rustPlatform.bindgenHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
