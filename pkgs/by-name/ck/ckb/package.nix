{
  cmake,
  fetchFromGitHub,
  lib,
  ckb,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  versionCheckHook,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ckb";
  version = "0.202.0";

  src = fetchFromGitHub {
    owner = "nervosnetwork";
    repo = "ckb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LE+w5RHkDk+1Zu2RZgPyHbHJ92C1oAxGEcVc3Qo2lQc=";
  };

  cargoHash = "sha256-R7XV//e6n6afbad7HgwlcNwQRdO0xFZ0UGy1SU294Fs=";

  buildFeatures = lib.optionals (stdenv.hostPlatform.isDarwin) [ "portable" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = true;
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "The Nervos CKB is a public permissionless blockchain, and the layer 1 of Nervos network.";
    homepage = "https://www.nervos.org/";
    downloadPage = "https://github.com/nervosnetwork/ckb";
    changelog = "https://github.com/nervosnetwork/ckb/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jjy
    ];
    mainProgram = "ckb";
  };
})
