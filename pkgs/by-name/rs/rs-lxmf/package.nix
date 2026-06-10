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
  version = "0.9.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsLXMF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jba/uiQQUO3MdmF2+6AOtdbUXYW43yqplRFUGujN0Oo=";
  };

  postPatch = ''
    for crate in rns-crypto rns-wire rns-identity rns-link rns-protocol rns-transport rns-runtime rns-interface; do
      substituteInPlace Cargo.toml \
        --replace-fail "../rsReticulum/crates/$crate" "${rs-reticulum.src}/crates/$crate"
    done
  '';

  cargoHash = "sha256-ReWw16r9cYIEzilzSsFXYap9ZGhk1mrUVl/bKkQMcVA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust implementation of LXMF for Reticulum";
    homepage = "https://github.com/ratspeak/rsLXMF";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "lxmd-rs";
  };
})
