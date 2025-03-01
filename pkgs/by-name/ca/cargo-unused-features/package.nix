{
  lib,
  rustPlatform,
  fetchCrate,
  curl,
  pkg-config,
  libgit2,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-unused-features";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-gdwIbbQDw/DgBV9zY2Rk/oWjPv1SS/+oFnocsMo2Axo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-IiS4d6knNKqoUkt0sRSJ+vNluqllS3mTsnphrafugIo=";

  nativeBuildInputs = [
    curl.dev
    pkg-config
  ];

  buildInputs =
    [
      curl
      libgit2
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "Tool to find potential unused enabled feature flags and prune them";
    homepage = "https://github.com/timonpost/cargo-unused-features";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
    mainProgram = "unused-features";
  };
}
