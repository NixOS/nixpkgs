{ lib
, rustPlatform
, fetchFromGitHub
, autoconf
, automake
, libtool
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-szPMbcR6fg9mgJ0oE07aYTJZHJKbguK3IFKhuV0D/rI=";
  };

  cargoHash = "sha256-vEyWawtWT/8GntlEUyrtBRXPcjgMg9oYemGzHSg50Hg=";

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
