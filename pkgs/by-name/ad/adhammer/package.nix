{
  lib,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adhammer";
  version = "1.4.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "icedracon";
    repo = "adhammer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jn3hmCSpc/9zxfIzebrCkDOgZ4HzfXdKOcJSXNvxZGM=";
  };

  cargoHash = "sha256-037x5bhTizcCqW/pszIadAVA9ElQzJOQ9W1dh5Kpg9Y=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Active Directory security-assessment toolkit";
    homepage = "https://github.com/icedracon/adhammer";
    changelog = "https://github.com/icedracon/adhammer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "adhammer";
  };
})
