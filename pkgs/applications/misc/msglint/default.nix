{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "msglint";
  version = "1.04";

  sourceRoot = ".";

  src = fetchurl {
    url = "https://tools.ietf.org/tools/msglint/msglint-${version}.tar.gz";
    sha256 = "1yasj6nijip3z86m526bsssd5vgqrx233azvpz1c0z564wngvzbm";
  };

  patches = [ ./fixfree.patch ];

  installPhase = ''
    mkdir -p $out/bin
    cp msglint $out/bin/msglint
  '';

  meta = with stdenv.lib; {
    description  = "RFC 822/MIME/DSN/MDN/Tracking-Status message validator.";
    homepage     = "https://tools.ietf.org/tools/msglint/";
    maintainers  = with maintainers; [ apeyroux ];
    license      = licenses.mit;
  };
}
