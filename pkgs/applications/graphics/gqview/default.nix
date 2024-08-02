{ lib, stdenv, fetchurl, pkg-config, gtk2, libpng }:

stdenv.mkDerivation rec {
  pname = "gqview";
  version = "2.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/gqview/gqview-${version}.tar.gz";
    sha256 = "0ilm5s7ps9kg4f5hzgjhg0xhn6zg0v9i7jnd67zrx9h7wsaa9zhj";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk2 libpng ];

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = "-fcommon";
  NIX_LDFLAGS = "-lm";

  meta = with lib; {
    description = "Fast image viewer";
    homepage = "https://gqview.sourceforge.net";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ ];
    mainProgram = "gqview";
  };
}
