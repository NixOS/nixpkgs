{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  pkg-config,
  aws-lc,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "icann-rdap";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "icann";
    repo = "icann-rdap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0UF9lDIX1gBxnGbt1sgDgOEyw/nBKvtSsVJ6zMiCROw=";
  };

  # Tests clear $HOME, on Darwin this makes `ProjectDirs` fail in the sandbox
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace icann-rdap-cli/tests/integration/test_jig.rs \
      --replace-fail '.create("cache", FileType::Dir)' '.create("home", FileType::Dir).create("cache", FileType::Dir)' \
      --replace-fail '.timeout(Duration::from_secs(2))' '.timeout(Duration::from_secs(2)).env("HOME", self.test_dir.path("home"))'
  '';

  cargoHash = "sha256-F95MrV6BpAA9cJpCkuhL4YuvjdHm+nyso87sgyAfp48=";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    pkg-config
  ];

  buildInputs = [
    aws-lc
    openssl
  ];

  cargoBuildFlags = [
    "--workspace"
    "--exclude=downstream_compat"
  ];

  __darwinAllowLocalNetworking = true;
  env = {
    OPENSSL_NO_VENDOR = true;
  };

  checkFlags = [
    # Requires network access to data.iana.org
    "--skip=iana::bootstrap::test::test_bootstrap_variant_dispatches_correctly"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = lib.optional stdenv.hostPlatform.isDarwin "HOME";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ICANN implementation of the Registry Data Access Protocol (RDAP)";
    homepage = "https://github.com/icann/icann-rdap";
    changelog = "https://github.com/icann/icann-rdap/releases/tag/${
      finalAttrs.src.tag or "v${finalAttrs.version}"
    }";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "rdap";
  };
})
