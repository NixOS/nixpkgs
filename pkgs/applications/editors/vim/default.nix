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
	["pythonSupport" "python"]
	["perlSupport" "perl"]
	["tclSupport" "tcl"]
	["eclSupport" "ecl" "gmp" "mpfr"]
	["true" "ncurses"]
	["false" "libSM"]
	];
	nameSuffixes = [
	"hugeFeatures" "-huge"
	"x11Support" "-X11"
	"pythonSupport" "-python"
	"perlSupport" "-perl"
	"tclSupport" "-tcl"
	"ximSupport" "-xim"
	"eclSupport" "-ecl"
	];
	configFlags = [
	"true" " --enable-multibyte "
	"x11Support" " --enable-gui=auto "
	"hugeFeatures" "--with-features=huge --enable-cscope --enable-xsmp "
	"pythonSupport" " --enable-pythoninterp "
	"perlSupport" " --enable-perlinterp "
	"tclSupport" " --enable-tclinterp "
	"ximSupport" " --enable-xim "
	"eclSupport" " --enable-eclinterp "
	];
	buildInputsNames = args.lib.filter (x: (null!=getVal x)) 
		(args.lib.uniqList {inputList = 
		(args.lib.concatLists (map 
		(x:(if (x==[]) then [] else builtins.tail x)) 
		reqsList));});
in
	assert args.lib.checkReqs args defList reqsList;
args.stdenv.mkDerivation {
  name = args.lib.condConcat "vim-7.2" nameSuffixes check;
 
  src = args.lib.attrByPath ["src"] (args.fetchurl {
    url = ftp://ftp.vim.org/pub/vim/unix/vim-7.2.tar.bz2;
    sha256 = "11hxkb6r2550c4n13nwr0d8afvh30qjyr5c2hw16zgay43rb0kci";
  }) args;
 
  inherit (args) ncurses;

  buildInputs = args.lib.filter (x: (x!=null)) (map getVal buildInputsNames);

  postInstall = "ln -s $out/bin/vim $out/bin/vi";
  preBuild="touch src/auto/link.sed";
  configureFlags = args.lib.condConcat "" configFlags check;

  NIX_LDFLAGS = "-lpthread -lutil";

  meta = {
    description = "The most popular clone of the VI editor";
    homepage = http://www.vim.org;
  };
}
