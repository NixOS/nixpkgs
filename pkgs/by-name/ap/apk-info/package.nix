{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apk-info";
  version = "1.0.13";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "delvinru";
    repo = "apk-info";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+ToIYtzbC6xYrmGHbbCDifqe0IMUevW92aKhoCf9r3k=";
  };

  cargoHash = "sha256-6BP9O4J21I2Pi9Fa0DuzD5wljgGVwsfoDDNyoQQ2dLQ=";

  nativeBuildInputs = [ python3 ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, malware-robust parser for Android APK/XAPK/APKM files";
    homepage = "https://github.com/delvinru/apk-info";
    changelog = "https://github.com/delvinru/apk-info/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "apk-info";
  };
})
