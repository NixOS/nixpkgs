{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rsClock";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "valebes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bxka9qTow5aL8ErYQudB+WRi2HecYn4/M3lBSxjd5/U=";
  };

  cargoHash = "sha256-ESBeXLBkDAmuQkazcXYdo5VnMCTaxfZmzKP+d5V4lEo=";

  meta = with lib; {
    description = "A simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [valebes];
  };
}
