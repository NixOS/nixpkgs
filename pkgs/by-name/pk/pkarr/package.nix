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

  useFetchCargoVendor = true;
  cargoHash = "sha256-y20vVO714WPcB2aYzo0LBuJhy224bsHA7O9Dj00ViWE=";

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
