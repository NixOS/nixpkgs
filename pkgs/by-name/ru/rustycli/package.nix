{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustycli";
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4Txw6Cmwwgu7K8VIVoX9GR76VUqAEw6uYptmczbjqg0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QjkUiPwjG25NsvAXM3jqQVtJzYiXhzVqFaDN1b7DXDE=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # some examples fail to compile
  cargoTestFlags = [ "--tests" ];

  meta = with lib; {
    description = "Access the rust playground right in terminal";
    mainProgram = "rustycli";
    homepage = "https://github.com/pwnwriter/rustycli";
    changelog = "https://github.com/pwnwriter/rustycli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
