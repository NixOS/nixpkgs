{ lib
, rustPlatform
, fetchFromGitHub
, llvmPackages
, rocksdb
}:

rustPlatform.buildRustPackage rec {
  pname = "electrs";
  version = "0.8.12";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kd5zki9f1pnwscnvd921dw0lc45nfkwk23l33nzdjn005lmsw7v";
  };

  cargoSha256 = "1l8dwjwj21crxampzj5c0k98xnisgy3d9c3dkgf5vaybrcp04k85";

  # needed for librocksdb-sys
  nativeBuildInputs = [ llvmPackages.clang ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # link rocksdb dynamically
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  cargoBuildFlags = "--no-default-features";

  meta = with lib; {
    description = "An efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
