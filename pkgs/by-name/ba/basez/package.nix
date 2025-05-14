{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "basez";
  version = "1.6.2";

  src = fetchurl {
    url = "http://www.quarkline.net/basez/download/basez-${version}.tar.gz";
    sha256 = "sha256-Kp+CFIh5HCdj7wEgx1xD3IPdFlZ7fEFvMDMYif1ZiTc=";
  };

  doCheck = true;

  meta = with lib; {
    description = "Base 16/32/64 encode/decode data to standard output";
    longDescription = ''
      Encode  data into/decode data from base16, base32, base32hex, base64 or
      base64url stream per RFC 4648;  MIME  base64  Content-Transfer-Encoding
      per RFC 2045; or PEM Printable Encoding per RFC 1421.
    '';
    homepage = "http://www.quarkline.net/basez/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.oaksoaj ];
    platforms = platforms.all;
  };
}
