{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cliflux";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "spencerwi";
    repo = "cliflux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oBjflPZooZatZCvKLA8h0BMuj++2tPrhE365zTk7vhM=";
  };

  cargoHash = "sha256-Q+/sh7Wku40SyhmgGci1YgCXQuEu1Zf4DaRDlDqWpak=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal client for Miniflux RSS reader";
    homepage = "https://github.com/spencerwi/cliflux";
    changelog = "https://github.com/spencerwi/cliflux/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "cliflux";
  };
})
