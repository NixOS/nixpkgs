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
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "fastfetch-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q6+NqZ8hw7fH/yZIOsNJIuMTk8E3/cso4lx4abcUHT0=";
  };

  cargoHash = "sha256-qOFRPw0uNg3LOAhRPoMoAV6k629SBuXuMu/dD5yFSLQ=";

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
