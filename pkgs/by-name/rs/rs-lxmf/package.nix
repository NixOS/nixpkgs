{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rs-reticulum,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rs-lxmf";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsLXMF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VxtuDM34EnDya/OPA9H+ihrAdueczqjXsjQZMYenDIE=";
  };

  postPatch = ''
    for crate in rns-crypto rns-wire rns-identity rns-link rns-protocol rns-transport rns-runtime rns-interface; do
      substituteInPlace Cargo.toml \
        --replace-fail "../rsReticulum/crates/$crate" "${rs-reticulum.src}/crates/$crate"
    done
  '';

  cargoHash = "sha256-qMDqCH2oCZDJ8TQTDtgxooL1Ltn4khVyXr186NfWtKY=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ratspeak/rsLXMF/releases/tag/${finalAttrs.src.tag}";
    description = "Rust implementation of LXMF for Reticulum";
    homepage = "https://github.com/ratspeak/rsLXMF";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "lxmd-rs";
  };
})
