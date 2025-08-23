{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "acorns";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "redhat-documentation";
    repo = "acorns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2iun+Yw2CZwv0TRTdmiqMXy52k+Gszn+bGTBvG9hJe0=";
  };

  cargoHash = "sha256-H/CyXdc9bKZx2cJpwas4oCSgdUZLfJdHNrqXavEHHTw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Generate an AsciiDoc release notes document from tracking tickets";
    homepage = "https://redhat-documentation.github.io/acorns/";
    downloadPage = "https://github.com/redhat-documentation/acorns";
    changelog = "https://github.com/redhat-documentation/acorns/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "acorns";
  };
})
