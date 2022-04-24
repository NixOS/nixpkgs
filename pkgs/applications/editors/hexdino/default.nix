{ lib, fetchFromGitHub, rustPlatform, ncurses }:

rustPlatform.buildRustPackage rec {
  pname = "hexdino";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Luz";
    repo = pname;
    rev = version;
    sha256 = "1n8gizawx8h58hpyyqivp7vwy7yhn6scipl5rrbvkpnav8qpmk1r";
  };

  cargoSha256 = "01869b1d7gbsprcxxj7h9z16pvnzb02j2hywh97gfq5x96gnmkz3";

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "A hex editor with vim like keybindings written in Rust";
    homepage = "https://github.com/Luz/hexdino";
    license = licenses.mit;
    maintainers = [ maintainers.luz ];
  };
}
