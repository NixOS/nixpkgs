{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fastfetch-rs";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "fastfetch-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7QM9iR55gR9oTQ21yZwu43btORbVmsEdiwoo+oLfce8=";
  };

  cargoHash = "sha256-34iE8NjC7mQdCuZhMtoI2Iq2O1aP3Ywy3Y25ex+XMxo=";

  postInstall = ''
    mkdir -p $out/share/fastfetch-rs
    cp -r src/logo/ascii $out/share/fastfetch-rs/logos
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast system information tool written in Rust inspired by fastfetch.";
    homepage = "https://github.com/liberodark/fastfetch-rs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "fastfetch-rs";
  };
})
