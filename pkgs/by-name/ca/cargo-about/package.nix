{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-h5+Fp6+yGa1quJENsCv6WE4NC2A+ceIGMXVWyeTPPLQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JTcRYdBZdXxM7r+XZSbFaAeWrJ5HULM1YE3p3smRW/Q=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      evanjs
      figsoda
      matthiasbeyer
    ];
    mainProgram = "cargo-about";
  };
}
