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

  cargoHash = "sha256-/uAxIV7eroJNGsLl4T/6RskoTIWKu5Cgmv48eMkDZQw=";

  meta = with lib; {
    description = "A simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [ valebes ];
    mainProgram = "rsclock";
  };
}
