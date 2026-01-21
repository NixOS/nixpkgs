{
  lib,
  rustPlatform,
  # fetchCrate,
  fetchFromGitHub,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "nominal-streaming";
  version = "0.7.8";

  # src = fetchCrate {
  #   inherit pname version;
  #   hash = "sha256-kjucdE044iAxZsqOqJls7LY3h8sRcXkQ7pIXvQ4WlbU=";
  # };
  src = fetchFromGitHub {
    owner = "nominal-io";
    repo = "nominal-streaming";
    rev = "v${version}";
    hash = "sha256-cg0xtdKbSOdrJVdHr2bVwcmTrRvEHHjh3U8VFGIL688=";
  };

  cargoHash = "sha256-1GQtkvE2VU6Dzm4ApnVbRI1F9M7kllIe7LMM07CU8f0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ ];

  meta = {
    description = "Rust library for streaming data into Nominal Core";
    homepage = "https://github.com/nominal-io/nominal-streaming";
    license = lib.licenses.unfree;
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ alkasm ];
  };
}
