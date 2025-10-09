{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  openssl_3,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "fortanix-sgx-tools";
  version = "0.6.1";
  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ openssl_3 ];
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-IVkmZs3imzj8uN8kqEzN/Oio3H+Nqzu8ORjARNx1TpQ=";
  };

  cargoHash = "sha256-jYd9KRZgdBoVepmV4x4E3Y7h1SzSLv2clB0uPSWv8tE=";
  meta = {
    description = "Tools for building and running enclaves for the Fortanix SGX ABI";
    homepage = "https://github.com/fortanix/rust-sgx";
    maintainers = [ lib.maintainers.ozwaldorf ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mpl20;
  };
}
