{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "acorns";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "redhat-documentation";
    repo = "acorns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f8JEySpICsek4P05DbA605VFM84Bede0R4XlFPGsIOA=";
  };

  cargoHash = "sha256-n5zhRw795RS+KPU8haa4PtdSxXOM0sfxmPTqcfcvDQw=";

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
