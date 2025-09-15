{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-EHqivIsS3wWvm3kJylynyobAsN2OlogXwLv9WdvzvJg=";
  };

  cargoHash = "sha256-J3kSBu81jQ/u6uLOT3pKFl4tfE6qOABWhpEea1O0BZI=";

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
