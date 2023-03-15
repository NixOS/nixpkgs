{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hexdino";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Luz";
    repo = pname;
    rev = version;
    sha256 = "sha256-OFtOa6StpOuLgkULnY5MlqDcSTEiMxogowHIBEiGr4E=";
  };

  cargoSha256 = "sha256-lvLiRQNH3rpu+JTXWhQtXczmGRWGtnnLDknZaMp3d0s=";

  meta = with lib; {
    description = "A hex editor with vim like keybindings written in Rust";
    homepage = "https://github.com/Luz/hexdino";
    license = licenses.mit;
    maintainers = [ maintainers.luz ];
  };
}
