{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rsClock";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "valebes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i93qkz6d8sbk78i4rvx099hnn4lklp4cjvanpm9ssv8na4rqvh2";
  };

  cargoSha256 = "076vxiz569nd3phancbf4crdv9snv3818hlgghfy2y5w54z448gp";

  meta = with lib; {
    description = "A simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [valebes];
  };
}
