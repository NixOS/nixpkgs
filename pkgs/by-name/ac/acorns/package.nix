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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "redhat-documentation";
    repo = "acorns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CBaOgiWBECuu41FwirwL+p+DZOPMz8ICf74YgmNnTRA=";
  };

  cargoHash = "sha256-fv3S3PRguoGG9wbwfitfH2TpNNOkhzT/CUPsgJLOhF4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

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
