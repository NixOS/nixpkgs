{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-spellcheck";
  version = "0.15.7";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = "cargo-spellcheck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tKf1PiQ1ojAbW+RKut+QczPy0wIfQcsthV4lRwvmjUw=";
  };

  cargoHash = "sha256-0TsDcdO7qCVcj6eNVu/lcehwsO2IhpNzW1C9zLbXXJs=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=gnu17";

  preCheck = "HOME=$(mktemp -d)";

  checkFlags = [
    "--skip=checker::hunspell::tests::hunspell_binding_is_sane"
    # requires dictionaries
    "--skip=tests::e2e::issue_226"
  ];

  meta = {
    description = "Checks rust documentation for spelling and grammar mistakes";
    mainProgram = "cargo-spellcheck";
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    changelog = "https://github.com/drahnr/cargo-spellcheck/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      newam
      matthiasbeyer
      chrjabs
    ];
  };
})
