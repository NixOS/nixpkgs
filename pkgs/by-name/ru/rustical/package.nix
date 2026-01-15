{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustical";
  version = "0.11.10";

  src = fetchFromGitHub {
    owner = "lennart-k";
    repo = "rustical";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+XGYM12RO0+bUpt7mIP7qm1CoYDnJYRNtkxVRyoH32g=";
  };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'rust-version = "1.92"' 'rust-version = "1.91"'
  '';

  cargoHash = "sha256-9GF7ViELoUxOxccyhFJehfRm7KuQIbv2wp9xIKkCpPQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  meta = {
    description = "Yet another calendar server aiming to be simple, fast and passwordless";
    homepage = "https://github.com/lennart-k/rustical";
    changelog = "https://github.com/lennart-k/rustical/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
    mainProgram = "rustical";
  };
})
