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
  version = "0.5.1";
  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ openssl_3 ];
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-F0lZG1neAPVvyOxUtDPv0t7o+ZC+aQRtpFeq55QwcmE=";
  };
  cargoHash = "sha256-jYfsmPwhvt+ccUr4Vwq5q1YzNlxA+Vnpxd4KpWZrYo8=";
  meta = {
    description = "Tools for building and running enclaves for the Fortanix SGX ABI";
    homepage = "https://github.com/fortanix/rust-sgx";
    maintainers = [ lib.maintainers.ozwaldorf ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mpl20;
  };
}
