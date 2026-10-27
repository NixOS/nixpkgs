{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "check-if-email-exists";
  version = "0.11.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "reacherhq";
    repo = "check-if-email-exists";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x82NioTCi+NwPFHPV511sYrKSAXUkFAuTMS+X9l5cuA=";
  };

  cargoHash = "sha256-IWg6dlS8ohnuB5XkSMi4cfMiqbCy93kTMMHgCkyRNho=";

  # upstream forgot to bump crate version
  postPatch = ''
    substituteInPlace cli/Cargo.toml \
      --replace-fail 'version = "0.11.8"' 'version = "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = 1;

  # require network
  checkFlags = [
    "--skip=smtp::tests::should_timeout"
    "--skip=tests::test_input_foo_bar_baz"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Check if an email address exists without sending any email";
    homepage = "https://github.com/reacherhq/check-if-email-exists";
    changelog = "https://github.com/reacherhq/check-if-email-exists/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "check_if_email_exists";
  };
})
