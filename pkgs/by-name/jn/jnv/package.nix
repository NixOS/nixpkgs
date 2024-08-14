{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-WrvCiZA/aYj0CoTq/kw3Oa3WKTjdtO6OC+IOxBoWjSU=";
  };

  cargoHash = "sha256-xF0sxoSo7z7lxrF3wFAmU7edREoWKBFBnZ6Xq22c8q0=";

  meta = with lib; {
    description = "Interactive JSON filter using jq";
    mainProgram = "jnv";
    homepage = "https://github.com/ynqa/jnv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nealfennimore nshalman ];
  };
}
