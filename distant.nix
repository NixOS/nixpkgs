{ lib, fetchFromGitHub, rustPlatform, perl, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "distant";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "chipsenkbeil";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DcnleJUAeYg3GSLZljC3gO9ihiFz04dzT/ddMnypr48=";
  };

  cargoHash = "sha256-7MNNdm4b9u5YNX04nBtKcrw+phUlpzIXo0tJVfcgb40=";
  nativeBuildInputs = [ pkg-config perl ];
  buildInputs = [ openssl ];
  doCheck = false;

  meta = {
    description = "Distant - A fast, secure remote development tool";
    homepage = "https://github.com/chipsenkbeil/distant";
    license = lib.licenses.mit;
    maintainers = [ "chipsenkbeil" "westernwontons" ];
  };
}


