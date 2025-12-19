{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-license";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bOBrjChkQM6POZZn53JmJcIn1x+ygF5mthZihMskxIk=";
  };

  cargoHash = "sha256-VQ8320yxMo102UZ9iO9n7ujq7d6wUuqOnQB02hxHZas=";

  meta = {
    description = "Cargo subcommand to see license of dependencies";
    mainProgram = "cargo-license";
    homepage = "https://github.com/onur/cargo-license";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      basvandijk
      matthiasbeyer
    ];
  };
}
