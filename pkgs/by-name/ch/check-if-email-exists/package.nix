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
  version = "0.11.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "reacherhq";
    repo = "check-if-email-exists";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KRnSTufgpmT6Yo+7NcaRARjtXOCwvbcXXX4or8YTmjo=";
  };

  cargoHash = "sha256-syuwY4qpnvWTXDZ6onnpFSmiEs1GCttSDtR5+vzuUDY=";

  # upstream forgot to bump crate version
  postPatch = ''
    substituteInPlace cli/Cargo.toml \
      --replace-fail 'version = "0.11.6"' 'version = "${finalAttrs.version}"'
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
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "check_if_email_exists";
  };
})
