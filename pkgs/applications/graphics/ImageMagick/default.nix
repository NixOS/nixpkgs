args: with args;
(stdenv.mkDerivation ({
  name = "ImageMagick-6.3.7-9";

  src = fetchurl {
    url = ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.3.7-9.tar.bz2;
    sha256 = "1s38s78xvzm20ib22zypsb9vvzva0kbqjf0pf4c1q89jzg205pk0";
  };

  configureFlags = " --with-dots --with-gs-font-dir="+ ghostscript +
		"/share/ghostscript/fonts --with-gslib " +(
		if args ? tetex then " --with-frozenpaths " else ""
		);

  buildInputs = [bzip2 freetype ghostscript graphviz libjpeg libpng 
		libtiff libX11 libxml2 zlib ] ++ (if args ? tetex then [args.tetex] else [])
		 ++ (if args ? librsvg then [args.librsvg] else [])
		;
} // (if args ? tetex then {
	preConfigure = "
		export DVIDecodeDelegate=${args.tetex}/bin/dvips
	";
} else {})))
