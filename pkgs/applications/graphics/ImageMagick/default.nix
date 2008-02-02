args: with args;
stdenv.mkDerivation (rec {
  name = "ImageMagick-6.3.8-2";

  src = fetchurl {
    url = "ftp://ftp.imagemagick.org/pub/ImageMagick/${name}.tar.bz2";
    sha256 = "05bp10dzpw691w8hdw0n2xr65194xgslpqhzf4xbxla7gz8clnmg";
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
