{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-H67lXwX+4guHpdq0yTHe6tl1NxC41saNrM9g+yH5otk=";
  };

  cargoHash = "sha256-B5kduRuX9Lcdd31yj4PsDo8fyy0nabtmsiAXvc8RlYo=";

  meta = with lib; {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "tftpd";
  };
}
