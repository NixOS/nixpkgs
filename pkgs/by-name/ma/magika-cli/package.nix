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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "magika";
    tag = "cli/v${finalAttrs.version}";
    hash = "sha256-rxkyC8/4nnVqfoubXiOchvmmGI1Z6dC8j2Oqpbt9kE0=";
  };

  cargoHash = "sha256-08dbfb4F2A3hB2xKKqR/+BNG7M74HG5UZi4ejULwVRw=";

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
    ORT_STRATEGY = "system";
    ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";

    # Required to prevent "ort-sys could not link to the ONNX Runtime build":
    # https://github.com/pykeio/ort/issues/517#issuecomment-3761926178
    ORT_PREFER_DYNAMIC_LINK = "true";
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

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
