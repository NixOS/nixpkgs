{ lib
, rustPlatform
, fetchFromGitHub
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "electrs";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    sha256 = "01fli2k5yh4iwlds97p5c36q19s3zxrqhkzp9dsjbgsf7sv35r3y";
  };

  # needed for librocksdb-sys
  nativeBuildInputs = [ llvmPackages.clang ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  cargoSha256 = "1rqpadlr9r4z2z825li6vi5a21hivc3bsn5ibxshrdrwiycyyxz8";

  meta = with lib; {
    description = "An efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
