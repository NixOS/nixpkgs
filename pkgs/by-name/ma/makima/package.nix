{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, udev
}:

rustPlatform.buildRustPackage rec{
  pname = "makima";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${version}";
    hash = "sha256-hHTWZ8FY+r+X7LTp+GvO9m58u8/zsaxmMJMNMb0KRaU=";
  };

  cargoHash = "sha256-CWqKV9MKnUSo9d5insrS1san7EtQvB3h5nY05ey5ZvQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    description = "Linux daemon to remap and create macros for keyboards, mice and controllers ";
    homepage = "https://github.com/cyber-sushi/makima";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "makima";
  };

}
