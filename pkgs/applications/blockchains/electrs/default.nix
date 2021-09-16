{ lib
, rustPlatform
, fetchFromGitHub
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "electrs";
  version = "0.8.11";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    sha256 = "024sdyvrx7s4inldamq4c8lv0iijjyd18j1mm9x6xf2clmvicaa6";
  };

  # needed for librocksdb-sys
  nativeBuildInputs = [ llvmPackages.clang ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  cargoSha256 = "0yl50ryxidbs9wkabz919mgbmsgsqjp1bjw792l1lkgncq8z9r5b";

  meta = with lib; {
    description = "An efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
