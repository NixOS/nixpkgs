args@{ fetchgit, stdenv, ncurses, pkgconfig, gettext
, lib, config, python, perl, tcl, ruby, qt4
, libX11, libXext, libSM, libXpm, libXt, libXaw, libXau, libXmu
, libICE
, lua
, features
, luaSupport       ? config.vim.lua or true
, perlSupport      ? config.vim.perl or false      # Perl interpreter
, pythonSupport    ? config.vim.python or true
, rubySupport      ? config.vim.ruby or true
, nlsSupport       ? config.vim.nls or false
, tclSupport       ? config.vim.tcl or false
, multibyteSupport ? config.vim.multibyte or false
, cscopeSupport    ? config.vim.cscope or false
, netbeansSupport  ? config.netbeans or true # eg envim is using it

# by default, compile with darwin support if we're compiling on darwin, but
# allow this to be disabled by setting config.vim.darwin to false
, darwinSupport    ? stdenv.isDarwin && (config.vim.darwin or true)

# add .nix filetype detection and minimal syntax highlighting support
, ftNixSupport     ? config.vim.ftNix or true

, ... }: with args;

let tag = "20140827";
    sha256 = "0ncgbcm23z25naicxqkblz0mcl1zar2qwgi37y5ar8q8884w9ml2";
in {

  name = "qvim-7.4." + tag;

  enableParallelBuilding = true; # test this

  src = fetchgit {
    url = https://bitbucket.org/equalsraf/vim-qt.git;
    rev = "refs/tags/package-" + tag;
    inherit sha256;
  };

  # FIXME: adopt Darwin fixes from vim/default.nix, then chage meta.platforms.linux
  # to meta.platforms.unix
  preConfigure = assert (! stdenv.isDarwin); "";

  configureFlags = [
    "--with-vim-name=qvim"
    "--enable-gui=qt"
    "--with-features=${features}"
    "--disable-xsmp"
    "--disable-xsmp_interact"
    "--disable-workshop"          # Sun Visual Workshop support
    "--disable-sniff"             # Sniff interface
    "--disable-hangulinput"       # Hangul input support
    "--disable-fontset"           # X fontset output support
    "--disable-acl"               # ACL support
    "--disable-gpm"               # GPM (Linux mouse daemon)
    "--disable-mzscheme"
  ]
  ++ stdenv.lib.optionals luaSupport [
    "--with-lua-prefix=${lua}"
    "--enable-luainterp"
  ]
  ++ stdenv.lib.optional pythonSupport      "--enable-pythoninterp"
  ++ stdenv.lib.optional (pythonSupport && stdenv.isDarwin) "--with-python-config-dir=${python}/lib"
  ++ stdenv.lib.optional nlsSupport         "--enable-nls"
  ++ stdenv.lib.optional perlSupport        "--enable-perlinterp"
  ++ stdenv.lib.optional rubySupport        "--enable-rubyinterp"
  ++ stdenv.lib.optional tclSupport         "--enable-tcl"
  ++ stdenv.lib.optional multibyteSupport   "--enable-multibyte"
  ++ stdenv.lib.optional darwinSupport      "--enable-darwin"
  ++ stdenv.lib.optional cscopeSupport      "--enable-cscope";

  nativeBuildInputs = [ ncurses pkgconfig libX11 libXext libSM libXpm libXt libXaw
    libXau libXmu libICE qt4
  ]
  ++ stdenv.lib.optional nlsSupport gettext
  ++ stdenv.lib.optional perlSupport perl
  ++ stdenv.lib.optional pythonSupport python
  ++ stdenv.lib.optional tclSupport tcl
  ++ stdenv.lib.optional rubySupport ruby
  ++ stdenv.lib.optional luaSupport lua
  ;

  postPatch = ''
  '' + stdenv.lib.optionalString ftNixSupport ''
    # because we cd to src in the main patch phase, we can't just add this
    # patch to the list, we have to apply it manually
    cd runtime
    patch -p2 < ${./ft-nix-support.patch}
    cd ..
  '';

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    rpath=`patchelf --print-rpath $out/bin/qvim`;
    for i in $nativeBuildInputs; do
      echo adding $i/lib
      rpath=$rpath:$i/lib
    done
    echo $nativeBuildInputs
    echo $rpath
    patchelf --set-rpath $rpath $out/bin/qvim
  '';

  dontStrip = 1;

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor (Qt GUI fork)";
    homepage    = https://bitbucket.org/equalsraf/vim-qt/wiki/Home;
    license = licenses.vim;
    maintainers = with maintainers; [ smironov ttuegel ];
    platforms   = platforms.linux;
  };
}

