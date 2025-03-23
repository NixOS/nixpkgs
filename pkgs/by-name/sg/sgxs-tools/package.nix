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
  version = "0.8.6";
  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ openssl_3 ];
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-24lUhi4IPv+asM51/BfufkOUYVellXoXsbWXWN/zoBw=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-7Jzr9Y6ixK1SHCHXaNKVXk0qfbtmXpr9dz1UNk7Q3XI=";
  meta = {
    description = "Utilities for working with the SGX stream format";
    homepage = "https://github.com/fortanix/rust-sgx";
    maintainers = [ lib.maintainers.ozwaldorf ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mpl20;
  };
}
