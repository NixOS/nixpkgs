{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-statuses";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "bircni";
    repo = "git-statuses";
    tag = finalAttrs.version;
    hash = "sha256-e4g4tiewhN5acrkGN9Y5+WO+ihogiJXmT4PlhLtyWcs=";
  };

  cargoHash = "sha256-IqlVwh80yTzVHWi5L+EQzt5SksK7SlBowZy46HnA+FI=";

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool to display the status of multiple Git repositories in a clear, tabular format";
    homepage = "https://github.com/bircni/git-statuses";
    changelog = "https://github.com/bircni/git-statuses/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "git-statuses";
  };
})
