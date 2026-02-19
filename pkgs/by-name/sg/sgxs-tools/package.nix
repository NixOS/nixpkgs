{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  openssl_3,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "sgxs-tools";
  version = "0.9.2";
  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ openssl_3 ];
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-vLbSjDULrYL8emQTha4fhEbr00OlhXNa00QhCKCnWDc=";
  };

  cargoHash = "sha256-5JMChgqFny9bB8ur/5koW3/YFCOVjb7cDsn4Ki2FSzA=";
  meta = {
    description = "Utilities for working with the SGX stream format";
    homepage = "https://github.com/fortanix/rust-sgx";
    maintainers = [ lib.maintainers.ozwaldorf ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mpl20;
  };
}
