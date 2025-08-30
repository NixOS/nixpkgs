{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-deny";
    rev = version;
    hash = "sha256-5aa13eFfGEJZBRB4/PAKKLwxw2wt8sBI7ZVOpgnO+t8=";
  };

  cargoHash = "sha256-RW+drxVouQbiZsjEL+XZBE2VMzEiCkLTOC9jMxI76T8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require internet access
  doCheck = false;

  meta = {
    description = "Cargo plugin for linting your dependencies";
    mainProgram = "cargo-deny";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      figsoda
      matthiasbeyer
      jk
    ];
  };
}
