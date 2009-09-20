args: with args;
stdenv.mkDerivation {
  name = "grip-1.0.19";

  src = fetchurl {
    url = http://prdownloads.sourceforge.net/grip/grip-3.2.0.tar.gz;
    sha256 = "1jh5x35rq15n8ivlp9wbdx8x9mj6agf5rfdv8sd6gai851zsclas";
  };

  buildInputs = [gtk glib pkgconfig libgnome libgnomeui vte curl];

  meta = { 
    description = "grip";
    homepage = http://nostatic.org/grip;
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
