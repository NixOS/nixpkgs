{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-script";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = "rust-script";
    rev = finalAttrs.version;
    hash = "sha256-Bb8ULD2MmZiSW/Tx5vAAHv95OMJ0EdWgR+NFhBkTlDU=";
  };

  cargoHash = "sha256-kxnylNZ8FsaR2S1o/p7qtlaXsBLDNv2PsFye0rcf/+A=";

  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];

  postInstall = ''
    wrapProgramBinary $out/bin/rust-script \
      --prefix PATH : ${lib.makeBinPath [ pkgs.cargo ]}
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # tests require network access
  # Upstream issue: https://github.com/fornwall/rust-script/issues/38
  doCheck = false;

  meta = {
    description = "Tool to run Rust files and expressions as scripts without any setup or compilation step";
    mainProgram = "rust-script";
    homepage = "https://rust-script.org";
    changelog = "https://github.com/fornwall/rust-script/blob/${finalAttrs.version}/CHANGELOG.md";
    downloadPage = "https://github.com/fornwall/rust-script/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      acuteaangle
    ];
  };
})
