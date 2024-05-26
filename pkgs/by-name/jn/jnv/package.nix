{ lib
, rustPlatform
, fetchFromGitHub
, autoconf
, automake
, libtool
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-yAyhXXWXsFkQq34aCG+IwE+wkYicu4vmOmX1uSs3R4o=";
  };

  cargoHash = "sha256-PcEQSp4GrMRT6zjbINSZ3lojkpvCyZC2fRHqnG6aPOw=";

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
