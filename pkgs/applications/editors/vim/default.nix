args:
let 
	defList = [];
	#stdenv and fetchurl are added automatically
	notForBuildInputs = []; 
	getVal = (args.lib.getValue args defList);
	check = args.lib.checkFlag args;
	reqsList = [
	["gtkGUI" "glib" "gtk" "pkgconfig" "libXpm" "libXext" "x11Support"]
	["athenaGUI" "libXau" "libXt" "libXaw" "libXpm" "libXext" "x11Support"]
	["x11Support" "libX11"]
	["hugeFeatures"]
	["true" "ncurses"]
	];
	buildInputsNames = args.lib.filter (x: (null!=getVal x)&&
		(! args.lib.isInList (notForBuildInputs ++ 
		["stdenv" "fetchurl" "lib"] ++ 
		(map builtins.head reqsList)) x)) 
		/*["libX11" "glib" "gtk" "pkgconfig" "libXpm" "libXext" 
			"libXau" "libXt" "libXaw" "ncurses"];*/
		(builtins.attrNames args);
in
	assert args.lib.checkReqs args defList reqsList;
args.stdenv.mkDerivation {
  name = "vim-7.1" +
	(if (check "hugeFeatures") then 
	"-huge" else "")
	+ (if (check "x11Support")
	then "-X11" else "")
	;
 
  src = args.fetchurl {
    url = ftp://ftp.nluug.nl/pub/editors/vim/unix/vim-7.1.tar.bz2;
    sha256 = "0w6gy49gdbw7hby5rjkjpa7cdvc0z5iajsm4j1h8108rvfam22kz";
  };
 
  inherit (args) ncurses;

  debug = builtins.attrNames args;
  buildInputs = args.lib.filter (x: x!=null) (map getVal buildInputsNames);
 
  preConfigure = "echo \$debug"; 
  postInstall = "ln -s $out/bin/vim $out/bin/vi";
  preBuild="touch src/auto/link.sed";
  configureFlags=" --enable-gui=auto --disable-xim "+
	(if (check "hugeFeatures") then 
	"--with-features=huge --enable-cscope --enable-multibyte --enable-xsmp "
	else "");

  meta = {
    description = "The most popular clone of the VI editor";
  };
}
