{ lib
, rustPlatform
, fetchFromGitHub
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "electrs";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = pname;
    rev = "v${version}";
    sha256 = "101prhxg7dr701gwm4s15maxb7cf65hf85hc7ai53b404v39vm71";
  };

  # needed for librocksdb-sys
  nativeBuildInputs = [ llvmPackages.clang ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  cargoSha256 = "12ypx0rkpbjl4awzx8ga30qhiqqd56a24q4jwlxxnfpw9ks1z252";

  meta = with lib; {
    description = "An efficient re-implementation of Electrum Server in Rust";
    homepage = "https://github.com/romanz/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
