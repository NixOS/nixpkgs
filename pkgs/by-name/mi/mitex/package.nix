{
  lib,
  fetchFromGitHub,
  rustPlatform,
  typst,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mitex";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "mitex-rs";
    repo = "mitex";
    tag = finalAttrs.version;
    hash = "sha256-ec/vocq+gU3zbFU2zNTLuHWmte9t8riYlgpS8BzxJBE=";
  };

  cargoHash = "sha256-AKQrIehctDlG06R21Ia14IC7Yj2/mq/VKPOyIdDBS2g=";

  nativeBuildInputs = [ typst ];

  buildAndTestSubdir = "crates/mitex-cli";

  cargoBuildFlags = [ "--features generate-spec" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "LaTeX support for Typst, CLI for MiTeX";
    homepage = "https://mitex-rs.github.io/mitex/";
    downloadPage = "https://github.com/mitex-rs/mitex";
    changelog = "https://github.com/mitex-rs/mitex/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ chillcicada ];
    license = lib.licenses.asl20;
    mainProgram = "mitex";
  };
})
