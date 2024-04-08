{ lib
, rustPlatform
, fetchFromGitHub
, autoconf
, automake
, libtool
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-22aoK1s8DhKttGGR9ouNDIWhYCv6dghT/jfAC0VX8Sw=";
  };

  cargoHash = "sha256-CmupwWwopXpnPm8R17JVfAoGt4QEos5I+3qumDKEyM8=";

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
