{ lib
, rustPlatform
, fetchCrate
, curl
, pkg-config
, libgit2
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-unused-features";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-gdwIbbQDw/DgBV9zY2Rk/oWjPv1SS/+oFnocsMo2Axo=";
  };

  cargoHash = "sha256-K9I7Eg43BS2SKq5zZ3eZrMkmuHAx09OX240sH0eGs+k=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2
    openssl
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "Tool to find potential unused enabled feature flags and prune them";
    homepage = "https://github.com/timonpost/cargo-unused-features";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
    mainProgram = "unused-features";
  };
}
