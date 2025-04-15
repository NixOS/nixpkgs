{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = "cfspeedtest";
    tag = "v${version}";
    hash = "sha256-Q1K5UcrSckEN+6W9UO2u07R3mZ6+J8E1ZYRZqnXif1s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-moYovJamW9xX3niO10bG9K3choDMV3wtuUSCn/5g1Yw=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "cfspeedtest";
  };
}
