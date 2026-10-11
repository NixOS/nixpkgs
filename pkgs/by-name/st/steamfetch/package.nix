{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  openssl,

  cacert,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "steamfetch";
  version = "0.5.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "steamfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V4lMSmf7mnSt7yNEwjy277XuzT2eUZoEemNXlhVi1as=";
  };

  cargoHash = "sha256-c+TeAJARsFmnXOISLEmR1XR0FAdn6ttfLbbOIr5yn6c=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  nativeCheckInputs = [ openssl ];
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  meta = {
    description = "Neofetch-like Steam stats grabber - display your profile in style";
    homepage = "https://github.com/unhappychoice/steamfetch";
    changelog = "https://github.com/unhappychoice/steamfetch/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "steamfetch";
  };
})
