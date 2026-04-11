{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitu";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q1U9a9GZJcpAF6VDqBGZW4eBW/5P6uz+C+/2+/vjqTM=";
  };

  cargoHash = "sha256-RP8n3RZzWA0AYhsRnblmzefRsT6+Qje2ah7eFYk69ow=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  nativeCheckInputs = [
    git
  ];

  meta = {
    description = "TUI Git client inspired by Magit";
    homepage = "https://github.com/altsem/gitu";
    changelog = "https://github.com/altsem/gitu/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evanrichter ];
    mainProgram = "gitu";
  };
})
