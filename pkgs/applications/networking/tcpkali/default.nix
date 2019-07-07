{stdenv, autoreconfHook, fetchFromGitHub, bison}:

let version = "1.1.1"; in

stdenv.mkDerivation rec {
  name = "tcpkali-${version}";
  src = fetchFromGitHub {
    owner = "machinezone";
    repo = "tcpkali";
    rev = "v${version}";
    sha256 = "09ky3cccaphcqc6nhfs00pps99lasmzc2pf5vk0gi8hlqbbhilxf";
  };
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ bison];
  meta = {
    description = "High performance TCP and WebSocket load generator and sink";
    license = stdenv.lib.licenses.bsd2;
    inherit (src.meta) homepage;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ethercrow ];
  };
}
