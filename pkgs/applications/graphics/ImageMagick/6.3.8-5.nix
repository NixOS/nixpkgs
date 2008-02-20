args: with args;
stdenv.mkDerivation (rec {
  name = "ImageMagick-6.3.8-5";

  src = fetchurl {
    url = "ftp://ftp.imagemagick.org/pub/ImageMagick/${name}.tar.bz2";
    sha256 = "0lsvi2z5b5zam6yvjzsyjpa36rg1c0kczifz73k9b4v8zz9a9vfl";
  };

  configureFlags = " --with-dots --with-gs-font-dir="+ ghostscript +
		"/share/ghostscript/fonts --with-gslib " +(
		if args ? tetex then " --with-frozenpaths " else ""
		);

  buildInputs = [bzip2 freetype ghostscript graphviz libjpeg libpng 
		libtiff libX11 libxml2 zlib libtool] ++ (if args ? tetex then [args.tetex] else [])
		 ++ (if args ? librsvg then [args.librsvg] else []);

  meta = {
    homepage = http://www.imagemagick.org;
  };
} // (if args ? tetex then {
	preConfigure = "
		export DVIDecodeDelegate=${args.tetex}/bin/dvips
	";
} else {}))
