args: 
args.stdenv.mkDerivation {
  name = "vim-7.1" +
	(if ((args ? hugeFeatures) 
	&& args.hugeFeatures) then 
	"-huge" else "")
	+ (if ((args ? libX11)&&(args.libX11 != null))
	then "-X11" else "")
	;
 
  src = args.fetchurl {
    url = ftp://ftp.nluug.nl/pub/editors/vim/unix/vim-7.1.tar.bz2;
    sha256 = "0w6gy49gdbw7hby5rjkjpa7cdvc0z5iajsm4j1h8108rvfam22kz";
  };
 
  inherit (args) ncurses;

  buildInputs =(with ({libX11=null; libXext=null;
	libSM=null; libXpm=null; libXt=null;
	libXaw=null; libXau=null; glib=null;
	gtk=null; pkgconfig=null;
	} // args); [ncurses] ++
	(args.lib.filter (x: x != null) 
	[libX11 libXext libSM libXpm libXt
	libXaw libXau glib gtk pkgconfig]));
  
  postInstall = "ln -s $out/bin/vim $out/bin/vi";
  preBuild="touch src/auto/link.sed";
  configureFlags=" --enable-gui=auto --disable-xim "+
	(if ((args ? hugeFeatures) && args.hugeFeatures) then 
	"--with-features=huge --enable-cscope --enable-multibyte --enable-xsmp "
	else "");

  meta = {
    description = "The most popular clone of the VI editor";
  };
}
