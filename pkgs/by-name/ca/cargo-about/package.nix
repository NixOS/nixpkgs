{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
<<<<<<< HEAD
  version = "0.8.4";
=======
  version = "0.8.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    tag = version;
<<<<<<< HEAD
    sha256 = "sha256-QbmZIbn/xPZUTXNpUjGuWTjoh8RpsMRuVIfJRO9M3xM=";
  };

  cargoHash = "sha256-oO5Kp5A2v1w6EUwgcHhyagZDIK7a/2d9uTiCoXHuHhY=";
=======
    sha256 = "sha256-cNKZpDlfqEXeOE5lmu79AcKOawkPpk4PQCsBzNtIEbs=";
  };

  cargoHash = "sha256-NnocSs6UkuF/mCM3lIdFk+r51Iz2bHuYzMT/gEbT/nk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
      matthiasbeyer
    ];
    mainProgram = "cargo-about";
  };
}
