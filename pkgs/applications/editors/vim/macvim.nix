{ stdenv, fetchFromGitHub, ncurses, gettext
, pkgconfig, cscope, python, ruby, tcl, perl, luajit
, darwin
}:

stdenv.mkDerivation rec {
  name = "macvim-${version}";

  version = "7.4.909";

  src = fetchFromGitHub {
    owner = "macvim-dev";
    repo = "macvim";
    rev = "75aa7774645adb586ab9010803773bd80e659254";
    sha256 = "0k04jimbms6zffh8i8fjm2y51q01m5kga2n4djipd3pxij1qy89y";
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
      "--without-local-dir"
      "--with-luajit"
      "--with-lua-prefix=${luajit}"
      "--with-ruby-command=${ruby}/bin/ruby"
      "--with-tclsh=${tcl}/bin/tclsh"
      "--with-tlib=ncurses"
      "--with-compiledby=Nix"
  ];

  makeFlags = ''PREFIX=$(out) CPPFLAGS="-Wno-error"'';

  # This is unfortunate, but we need to use the same compiler as XCode,
  # but XCode doesn't provide a way to configure the compiler.
  #
  # If you're willing to modify the system files, you can do this:
  #   http://hamelot.co.uk/programming/add-gcc-compiler-to-xcode-6/
  #
  # But we don't have that option.
  preConfigure = ''
    CC=/usr/bin/clang

    DEV_DIR=$(/usr/bin/xcode-select -print-path)/Platforms/MacOSX.platform/Developer
    configureFlagsArray+=(
      "--with-developer-dir=$DEV_DIR"
    )
  '';

  postConfigure = ''
    substituteInPlace src/auto/config.mk --replace "PERL_CFLAGS	=" "PERL_CFLAGS	= -I${darwin.libutil}/include"
  '';

  postInstall = ''
    mkdir -p $out/Applications
    cp -r src/MacVim/build/Release/MacVim.app $out/Applications
    rm -rf $out/MacVim.app

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
    description = "Vim - the text editor - for macOS";
    homepage    = https://github.com/b4winckler/macvim;
    license = licenses.vim;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = platforms.darwin;
  };
}
