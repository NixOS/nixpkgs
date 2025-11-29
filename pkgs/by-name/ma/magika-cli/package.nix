{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  onnxruntime,
  versionCheckHook,
  runCommand,
  writeText,
  testers,
  nix-update-script,
  magika-cli,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "magika-cli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "magika";
    tag = "cli/v${finalAttrs.version}";
    hash = "sha256-g/fnSdh2jpOHOLTuR4DUPB1kbC0eKADHLKcfB1q08XI=";
  };

  cargoHash = "sha256-uqnTyedry9nWyO2518r0D3hk6oWb4wQE/Ku0cOkSjBA=";

  cargoRoot = "rust/cli";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    onnxruntime
  ];

  env = {
    OPENSSL_NO_VENDOR = "true";
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru = {
    tests = {
      mime = testers.testEqualContents {
        assertion = "magika detects the correct language from content even when the file extension is wrong";

        # Magika does not support Nix files yet: https://github.com/google/magika/issues/1247
        expected = writeText "expected" ''
          application/x-rust
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [
                magika-cli
              ];
            }
            ''
              magika --format '%m' '${./test.md}' >>"$out"
            '';
      };
    };

    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^cli/v([0-9.]+)$" ];
    };
  };

  meta = {
    description = "Determines file content types using AI";
    homepage = "https://securityresearch.google/magika/";
    downloadPage = "https://github.com/google/magika";
    changelog = "https://github.com/google/magika/releases/tag/cli/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "magika";
    platforms = with lib.platforms; unix ++ windows;

    # The package test fails on Darwin with this error, even though the build succeeds:
    # libc++abi: terminating due to uncaught exception of type std::__1::system_error: mutex lock failed: Invalid argument
    broken = stdenv.hostPlatform.isDarwin;
  };
})
