{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = "cfspeedtest";
    tag = "v${version}";
    hash = "sha256-86PZlTwqplKCVZl6IG2Qch+IMdfiTfpBhdNf00XIXbU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-54gIhBuVl77NDGotbgcOJsPxZL3XdJBnDEDbNpbVSNk=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "cfspeedtest";
  };
}
