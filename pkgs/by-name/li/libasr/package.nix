{ lib, stdenv, fetchurl, libevent, openssl }:

stdenv.mkDerivation rec {
  pname = "libasr";
  version=  "1.0.4";

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${pname}-${version}.tar.gz";
    sha256 = "1d6s8njqhvayx2gp47409sp1fn8m608ws26hr1srfp6i23nnpyqr";
  };

  buildInputs = [ libevent openssl ];

  meta = with lib; {
    homepage = "https://github.com/OpenSMTPD/libasr";
    description = "Free, simple and portable asynchronous resolver library";
    license = licenses.isc;
    maintainers = [ maintainers.koral ];
    platforms = platforms.unix;
  };
}
