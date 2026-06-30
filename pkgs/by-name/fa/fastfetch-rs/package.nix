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
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "fastfetch-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jKIHs/PvUZIiSbs2HNBKx2x3LsMvdTbXvLFKuAUixq0=";
  };

  cargoHash = "sha256-vk76qIMxmm3fiIgo+0BF8GosNCAKrk3SJkhTqRQr9wI=";

  postInstall = ''
    mkdir -p $out/share/fastfetch-rs
    cp -r src/logo/ascii $out/share/fastfetch-rs/logos
  '';

  __structuredAttrs = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast system information tool written in Rust inspired by fastfetch";
    homepage = "https://github.com/liberodark/fastfetch-rs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "fastfetch-rs";
  };
})
