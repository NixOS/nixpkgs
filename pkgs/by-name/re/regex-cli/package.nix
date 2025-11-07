{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "regex-cli";
  version = "0.2.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ytI1C2QRUfInIChwtSaHze7VJnP9UIcO93e2wjz2/I0=";
  };

  cargoHash = "sha256-7fPoH6I8Okz8Oby45MIDdKBkbPgUPsaXd6XS3r3cRO8=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Command line tool for debugging, ad hoc benchmarking and generating regular expressions";
    mainProgram = "regex-cli";
    homepage = "https://github.com/rust-lang/regex/tree/master/regex-cli";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
