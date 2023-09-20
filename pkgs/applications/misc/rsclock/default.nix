{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rsClock";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "valebes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HsHFlM5PHUIF8FbLMJpleAvgsXHP6IZLuiH+umK1V4M=";
  };

  cargoHash = "sha256-0bUKiKieIic+d3jEow887i7j2tp/ntYkXm6x08Df64M=";

  meta = with lib; {
    description = "A simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [valebes];
  };
}
