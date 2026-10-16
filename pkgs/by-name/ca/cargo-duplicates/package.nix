{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-duplicates";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "cargo-duplicates";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bHVqAZetPrbWKhiMRaiCenOCK0ZPiF1F2D3Wa6+mrzw=";
  };

  cargoHash = "sha256-v7SEXhWyL+BCLWucYXG4dAoMqL57bPTKAUtQKCNu6FQ=";

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    zlib
  ];

  meta = {
    description = "Cargo subcommand for displaying when different versions of a same dependency are pulled in";
    mainProgram = "cargo-duplicates";
    homepage = "https://github.com/Keruspe/cargo-duplicates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
