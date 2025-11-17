{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "distant";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "chipsenkbeil";
    repo = "distant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DcnleJUAeYg3GSLZljC3gO9ihiFz04dzT/ddMnypr48=";
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoHash = "sha256-HEyPfkusgk8JEYAzIS8Zj5EU0MK4wt4amlsJqBEG/Kc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # Requires network access:
    # failed to lookup address information: Temporary failure in name resolution
    "--skip=options::common::address::tests::resolve_should_properly_resolve_bind_address"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Timeout on darwin
    # Custom { kind: TimedOut, error: "" }
    "--skip=cli::api::watch::should_support_json_reporting_changes_using_correct_request_id"
    "--skip=cli::api::watch::should_support_json_watching_directory_recursively"
    "--skip=cli::api::watch::should_support_json_watching_single_file"
    "--skip=cli::client::fs_watch::should_support_watching_a_directory_recursively"
    "--skip=cli::client::fs_watch::should_support_watching_a_single_file"
  ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Library and tooling that supports remote filesystem and process operations";
    homepage = "https://github.com/chipsenkbeil/distant";
    changelog = "https://github.com/chipsenkbeil/distant/blob/${finalAttrs.version}/CHANGELOG.md";
    # From the README:
    # "This project is licensed under either of Apache License, Version 2.0, MIT license at your option."
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "distant";
  };
})
