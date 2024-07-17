{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-IvpbVcTGGD7cn59SPlcqMuu9YXB3ur3AFaoWDVADoqI=";
  };

  cargoHash = "sha256-dqWQi0DYl2P1qPzmtYOcarnfu2bfSnLk/SVQq5d+Z8Y=";

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
    maintainers = with maintainers; [
      nealfennimore
      nshalman
    ];
  };
}
