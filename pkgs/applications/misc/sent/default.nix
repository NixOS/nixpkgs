{ stdenv, fetchurl, libpng, libX11, libXft }:

stdenv.mkDerivation rec {
  name = "sent-0.1";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "09fhq3qi0q6cn3skl2wd706wwa8wxffp0hrzm22bafzqxaxsaslz";
  };

  buildInputs = [ libpng libX11 libXft ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A simple plaintext presentation tool";
    homepage = http://tools.suckless.org/sent/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
