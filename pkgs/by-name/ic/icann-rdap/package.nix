{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  pkg-config,
  openssl,
  sqlite,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "icann-rdap";
  version = "0.0.29";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "icann";
    repo = "icann-rdap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HVD3hXiUfVXPC/9aqU+3QclJ9PLb5o6FNg7D4l5WP7k=";
  };

  # Tests clear $HOME, on Darwin this makes `ProjectDirs` fail in the sandbox
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace icann-rdap-cli/tests/integration/test_jig.rs \
      --replace-fail '.create("cache", FileType::Dir)' '.create("home", FileType::Dir).create("cache", FileType::Dir)' \
      --replace-fail '.timeout(Duration::from_secs(2))' '.timeout(Duration::from_secs(2)).env("HOME", self.test_dir.path("home"))'
  '';

  cargoHash = "sha256-Oew4RUbAs+IM2ipH680WemJ2jMjP5GnMw+pS4WEwg/k=";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  __darwinAllowLocalNetworking = true;
  env = {
    OPENSSL_NO_VENDOR = true;
  };

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
