{ lib, stdenv, fetchFromGitHub, perl, libxcb }:

stdenv.mkDerivation rec {
  pname = "lemonbar";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "LemonBoy";
    repo = "bar";
    rev = "v${version}";
    sha256 = "sha256-lmppcnQ8r4jEuhegpTBxYqxfTTS/IrbtQVZ44HqnoWo=";
  };

  buildInputs = [ libxcb perl ];

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    description = "A lightweight xcb based bar";
    homepage = "https://github.com/LemonBoy/bar";
    maintainers = with maintainers; [ meisternu moni ];
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "lemonbar";
  };
}
