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
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NpDTXTBHZs5o6HlOfpffOfo1S6Bw/oNxGuvRHzwv2II=";
  };

  cargoHash = "sha256-brGnoaaXTxGPHCAHh2i4NzUVxHySmT8H2jmC9le2v8Q=";

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
