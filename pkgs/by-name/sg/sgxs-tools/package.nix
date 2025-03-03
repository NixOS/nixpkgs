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
  cargoHash = "sha256-vtuOCLo7qBOfqMynykqf9folmlETx3or35+CuTurh3s=";
  meta = {
    description = "Utilities for working with the SGX stream format";
    homepage = "https://github.com/fortanix/rust-sgx";
    maintainers = [ lib.maintainers.ozwaldorf ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mpl20;
  };
}
