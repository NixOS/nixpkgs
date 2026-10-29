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
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CeIERUp7F6cUVxiJkufmxLHpfWHhwyLylg1Cr481Txw=";
  };

  cargoHash = "sha256-+oxSG9PfXWYXBIzi6ZsO0S4/iLNIZPvTHZgWDQkbkLs=";

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
