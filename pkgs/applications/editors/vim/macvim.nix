{ stdenv, stdenvAdapters, gccApple, fetchFromGitHub, ncurses, gettext,
  pkgconfig, cscope, python, ruby, tcl, perl, luajit
}:

let inherit (stdenvAdapters.overrideGCC stdenv gccApple) mkDerivation;
in mkDerivation rec {
  name = "macvim-${version}";

  version = "7.4.355";

  src = fetchFromGitHub {
    owner = "genoma";
    repo = "macvim";
    rev = "c18a61f9723565664ffc2eda9179e96c95860e25";
    sha256 = "190bngg8m4bwqcia7w24gn7mmqkhk0mavxy81ziwysam1f652ymf";
  };

  enableParallelBuilding = true;

  buildInputs = [
    gettext ncurses pkgconfig luajit ruby tcl perl python
  ];

  patches = [ ./macvim.patch ];

  postPatch = ''
    substituteInPlace src/MacVim/mvim --replace "# VIM_APP_DIR=/Applications" "VIM_APP_DIR=$out/Applications"

    # Don't create custom icons.
    substituteInPlace src/MacVim/icons/Makefile --replace '$(MAKE) -C makeicns' ""
    substituteInPlace src/MacVim/icons/make_icons.py --replace "dont_create = False" "dont_create = True"

    # Full path to xcodebuild
    substituteInPlace src/Makefile --replace "xcodebuild" "/usr/bin/xcodebuild"
  '';

  configureFlags = [
      #"--enable-cscope" # TODO: cscope doesn't build on Darwin yet
      "--enable-fail-if-missing"
      "--with-features=huge"
      "--enable-gui=macvim"
      "--enable-multibyte"
      "--enable-nls"
      "--enable-luainterp=dynamic"
      "--enable-pythoninterp=dynamic"
      "--enable-perlinterp=dynamic"
      "--enable-rubyinterp=dynamic"
      "--enable-tclinterp=yes"
      "--with-luajit"
      "--with-lua-prefix=${luajit}"
      "--with-ruby-command=${ruby}/bin/ruby"
      "--with-tclsh=${tcl}/bin/tclsh"
      "--with-tlib=ncurses"
      "--with-compiledby=Nix"
  ];

  preConfigure = ''
    DEV_DIR=$(/usr/bin/xcode-select -print-path)/Platforms/MacOSX.platform/Developer
    configureFlagsArray+=(
      "--with-developer-dir=$DEV_DIR"
    )
  '';

  postInstall = ''
    ensureDir $out/Applications
    cp -r src/MacVim/build/Release/MacVim.app $out/Applications

    rm $out/bin/{Vimdiff,Vimtutor,Vim,ex,rVim,rview,view}

    cp src/MacVim/mvim $out/bin
    cp src/vimtutor $out/bin

    for prog in "vimdiff" "vi" "vim" "ex" "rvim" "rview" "view"; do
      ln -s $out/bin/mvim $out/bin/$prog
    done

    # Fix rpaths
    exe="$out/Applications/MacVim.app/Contents/MacOS/Vim"
    libperl=$(dirname $(find ${perl} -name "libperl.dylib"))
    install_name_tool -add_rpath ${luajit}/lib $exe
    install_name_tool -add_rpath ${tcl}/lib $exe
    install_name_tool -add_rpath ${python}/lib $exe
    install_name_tool -add_rpath $libperl $exe
    install_name_tool -add_rpath ${ruby}/lib $exe
  '';

  meta = with stdenv.lib; {
    description = "Vim - the text editor - for Mac OS X";
    homepage    = https://github.com/b4winckler/macvim;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = platforms.darwin;
  };
}
