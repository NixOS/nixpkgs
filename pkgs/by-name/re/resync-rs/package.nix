{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resync-rs";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vedLinuxian";
    repo = "resync-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ssh2yt9d5QGyhrm03C5txD1WpU2D+hVZBqOsnO5n3PI=";
  };

  cargoHash = "sha256-rpNDEdzClqIGippLW5bnSVE+VOuT9vwfZ7NGvTMapZY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Next-generation parallel delta-sync engine — rsync reimagined in Rust";
    homepage = "https://github.com/vedLinuxian/resync-rs";
    changelog = "https://github.com/vedLinuxian/resync-rs/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paepcke ];
    mainProgram = "resync";
  };
})
