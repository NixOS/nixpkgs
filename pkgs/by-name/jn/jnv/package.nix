{ lib
, rustPlatform
, fetchFromGitHub
, autoconf
, automake
, libtool
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-CdpEo8hnO61I2Aocfd3nka81FTDPRguwxxcemzH+zcc=";
  };

  cargoHash = "sha256-KF15Y2VrFJ7p5ut5cR80agaJ7bM9U9Ikcz1Ux8Ah138=";

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
