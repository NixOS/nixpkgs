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
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsLXMF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fqSd+XZayW8mYdUF3MY/KjclvhfHtO1I4y1ot3EbdnA=";
  };

  postPatch = ''
    for crate in rns-crypto rns-wire rns-identity rns-link rns-protocol rns-transport rns-runtime rns-interface; do
      substituteInPlace Cargo.toml \
        --replace-fail "../rsReticulum/crates/$crate" "${rs-reticulum.src}/crates/$crate"
    done
  '';

  cargoHash = "sha256-Lv+mxsAtpzjd9tbMioZEH+7rvYVRiPYfD3icgQc+BrU=";

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
