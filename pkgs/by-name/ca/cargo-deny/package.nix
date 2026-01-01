{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-deny";
<<<<<<< HEAD
  version = "0.18.9";
=======
  version = "0.18.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-deny";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-2ZexBVt3+tnEwxtRuzS6f7BQyu/nvjC098221hadKw8=";
  };

  cargoHash = "sha256-2u1DQtvjRfwbCXnX70M7drrMEvNsrVxsbikgrnNOkUE=";
=======
    hash = "sha256-w3SFU0FSX7nmqzyxey0erJfq8YsFEEukfNhDg5g0I04=";
  };

  cargoHash = "sha256-yrVSXrxfJ4vB85rARq6g71AswRMXhn25tfYZqXm1zoo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      jk
    ];
  };
})
