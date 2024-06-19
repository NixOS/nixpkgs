{ lib
, rustPlatform
, fetchFromGitHub
, autoconf
, automake
, libtool
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-5Atop86g/gGgf4MEK/Q2vqpQ+KIS72FB2gXCH8U+L3g=";
  };

  cargoHash = "sha256-qpVRq6RbrDZDSJkLQ5Au9j2mWXp3gn7QBe3nRmIVK8c=";

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    rustPlatform.bindgenHook
  ];

  meta = with lib; {
    description = "Interactive JSON filter using jq";
    mainProgram = "jnv";
    homepage = "https://github.com/ynqa/jnv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nealfennimore nshalman ];
  };
}
