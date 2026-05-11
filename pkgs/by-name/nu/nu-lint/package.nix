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
  version = "0.1.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wvhulle";
    repo = "nu-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RU+Jy0AMesQpvndjF29IlJb2gpV76lm0Fz0Fk/i6RYU=";
  };

  cargoHash = "sha256-NbjeOtvvJhk/27Jg/jthdSZ09n/j37J2Y+yAIiVUia4=";

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
