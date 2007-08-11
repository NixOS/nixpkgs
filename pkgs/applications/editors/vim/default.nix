args:
let 
	defList = [];
	#stdenv and fetchurl are added automatically
	getVal = (args.lib.getValue args defList);
	check = args.lib.checkFlag args;
	reqsList = [
	["gtkGUI" "glib" "gtk" "pkgconfig" "libXpm" "libXext" "x11Support"]
	["athenaGUI" "libXau" "libXt" "libXaw" "libXpm" "libXext" "x11Support"]
	["x11Support" "libX11"]
	["hugeFeatures"]
	["true" "ncurses"]
	["false" "libSM"]
	];
	buildInputsNames = args.lib.filter (x: (null!=getVal x)) 
		(args.lib.uniqList {inputList = 
		(args.lib.concatLists (map 
		(x:(if (x==[]) then [] else builtins.tail x)) 
		reqsList));});
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

  buildInputs = args.lib.filter (x: (x!=null)) (map getVal buildInputsNames);

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
