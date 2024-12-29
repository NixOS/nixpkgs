{
  lib,
  fetchFromGitHub,
  darwin,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "pkarr";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "pubky";
    repo = "pkarr";
    rev = "v${version}";
    hash = "sha256-zJe/hCdGVqs2TTwxnceGVXt0ZFRheSRYzjSRHytYXks=";
  };

  cargoHash = "sha256-qRHxXlUDIpjhd/XeObnmEnjYk3SoiC56LWJUiut0BwY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      Security
      SystemConfiguration
    ]
  );

  meta = {
    description = "Public Key Addressable Resource Records (sovereign TLDs) ";
    homepage = "https://github.com/pubky/pkarr";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ dpc ];
    mainProgram = "pkarr-server";
  };
}
