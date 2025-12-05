{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustycli";
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4Txw6Cmwwgu7K8VIVoX9GR76VUqAEw6uYptmczbjqg0=";
  };

  cargoHash = "sha256-QjkUiPwjG25NsvAXM3jqQVtJzYiXhzVqFaDN1b7DXDE=";

  # some examples fail to compile
  cargoTestFlags = [ "--tests" ];

  meta = {
    description = "Access the rust playground right in terminal";
    mainProgram = "rustycli";
    homepage = "https://github.com/pwnwriter/rustycli";
    changelog = "https://github.com/pwnwriter/rustycli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
