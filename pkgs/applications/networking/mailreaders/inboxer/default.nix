{ stdenv, fetchFromGitHub, nodejs }:

stdenv.mkDerivation rec {
  name = "inboxer-${version}";
  version = "1.0.0";

  meta = with stdenv.lib; {
    description = "Unofficial, free and open-source Google Inbox Desktop App";
    homepage    = "https://denysdovhan.com/inboxer";
    maintainers = [ maintainers.mgttlinger ];
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "inboxer";
    rev = "v${version}";
    sha256 = "0mvkvsqc36y3r2lxa5f4rjrj2z5jxwadpcx585sdsx37ndi1z9m5";
  };

  buildInputs = [ nodejs ];

  buildPhase = ''
    npm install
    npm test
  '';
}
