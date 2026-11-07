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
  version = "1.7.1";

  src = fetchFromCodeberg {
    owner = "wvhulle";
    repo = "nu-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pzhI2ob330S03Gff+Rj0R6DnmMbsk5c5Sb87SVlkG3Y=";
  };

  cargoHash = "sha256-Weh68NGrSB5O4mtmp0r8UeJcZZ63ZuiP/C7S2TwQCc8=";

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
    maintainers = with lib.maintainers; [
      kpbaks
      wvhulle
    ];
    platforms = lib.platforms.all;
    mainProgram = "nu-lint";
  };
})
