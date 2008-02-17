args: with args;
(stdenv.mkDerivation (rec {
  name = "ImageMagick-6.3.7-10";

  src = fetchurl {
    url = "mirror://imagemagick/" + name + ".tar.bz2";
    sha256 = "c00fb0d21baa292a55bb0e30ca30ffe2571e0d3df9e692da441aa81ff1cdde10";
  };

  configureFlags = " --with-dots --with-gs-font-dir="+ ghostscript +
		"/share/ghostscript/fonts --with-gslib " +(
		if args ? tetex then " --with-frozenpaths " else ""
		);

  buildInputs = [bzip2 freetype ghostscript graphviz libjpeg libpng 
		libtiff libX11 libxml2 zlib libtool] ++ (if args ? tetex then [args.tetex] else [])
		 ++ (if args ? librsvg then [args.librsvg] else []);

  meta = {
    description = ''ImageMagick(R) is a software suite to create, edit, and compose bitmap
                    images.  It can read, convert and write images in a variety of
		    formats (over 100).'';
    homepage = http://www.imagemagick.org;
  };
} // (if args ? tetex then {
	preConfigure = "
		export DVIDecodeDelegate=${args.tetex}/bin/dvips
	";
} else {})))
