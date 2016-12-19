{stdenv, autoreconfHook, fetchFromGitHub, bison}:

let version = "0.9"; in

stdenv.mkDerivation rec {
  name = "tcpkali-${version}";
  src = fetchFromGitHub {
    owner = "machinezone";
    repo = "tcpkali";
    rev = "v${version}";
    sha256 = "03cbmnc60wkd7f4bapn5cbm3c4zas2l0znsbpci2mn8ms8agif82";
  };
  buildInputs = [autoreconfHook bison];
  meta = {
    description = "High performance TCP and WebSocket load generator and sink";
    license = stdenv.lib.licenses.bsd2;
    inherit (src.meta) homepage;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ethercrow ];
  };
}
