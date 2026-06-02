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
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rEhAMikMCPtpKz7GAAFxzJYYshtEeeuawgagnD4IJhU=";
  };

  cargoHash = "sha256-LZegPuUOSxg3a7Gl6bNMEvpKlD4BcaYgs3mc5EwIkTE=";

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
