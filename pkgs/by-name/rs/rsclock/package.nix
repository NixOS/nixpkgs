{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rsClock";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "valebes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z+WGi1Jl+YkdAc4Nu818vi+OXg54GfAM6PbWYkgptpo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Dt3TCqQWwBcQ/6ZGhsMS7aA0jsvxRrdYkKSwynOlad8=";

  meta = with lib; {
    description = "Simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [ valebes ];
    mainProgram = "rsclock";
  };
}
