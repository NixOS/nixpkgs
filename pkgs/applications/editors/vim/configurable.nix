# TODO tidy up eg The patchelf code is patching gvim even if you don't build it..
# but I have gvim with python support now :) - Marc
args:
let edf = args.lib.enableDisableFeature; in
( args.mkDerivationByConfiguration {
    # most interpreters aren't tested yet.. (see python for example how to do it)
    flagConfig = { 
      mandatory = { cfgOption = "--enable-gui=auto --with-features=${args.features}"; 
                    buildInputs = ["ncurses" "pkgconfig"];
                  };
      X11 = { buildInputs = [ "libX11" "libXext" "libSM" "libXpm" "libXt" "libXaw" "libXau" "libXmu" ]; };

    } // edf "darwin" "darwin" { } #Disable Darwin (Mac OS X) support.
      // edf "xsmp" "xsmp" { } #Disable XSMP session management
      // edf "xsmp_interact" "xsmp_interact" {  } #Disable XSMP interaction
      // edf "mzscheme" "mzschemeinterp" { } #Include MzScheme interpreter.
      // edf "perl" "perlinterp" { } #Include Perl interpreter.
      // edf "python" "pythoninterp" { pass = "python"; } #Include Python interpreter.
      // edf "tcl" "tclinterp" { } #Include Tcl interpreter.
      // edf "ruby" "rubyinterp" { } #Include Ruby interpreter.
      // edf "cscope" "cscope" { } #Include cscope interface.
      // edf "workshop" "workshop" { } #Include Sun Visual Workshop support.
      // edf "netbeans" "netbeans" { } #Disable NetBeans integration support.
      // edf "sniff" "sniff" { } #Include Sniff interface.
      // edf "multibyte" "multibyte" { } #Include multibyte editing support.
      // edf "hangulinput" "hangulinput" { } #Include Hangul input support.
      // edf "xim" "xim" { pass = "xim"; } #Include XIM input support.
      // edf "fontset" "fontset" { } #Include X fontset output support.

  #--enable-gui=OPTS     X11 GUI default=auto OPTS=auto/no/gtk/gtk2/gnome/gnome2/motif/athena/neXtaw/photon/carbon
    /*
      // edf "gtk_check" "gtk_check" { } #If auto-select GUI, check for GTK default=yes
      // edf "gtk2_check" "gtk2_check" { } #If GTK GUI, check for GTK+ 2 default=yes
      // edf "gnome_check" "gnome_check" { } #If GTK GUI, check for GNOME default=no
      // edf "motif_check" "motif_check" { } #If auto-select GUI, check for Motif default=yes
      // edf "athena_check" "athena_check" { } #If auto-select GUI, check for Athena default=yes
      // edf "nextaw_check" "nextaw_check" { } #If auto-select GUI, check for neXtaw default=yes
      // edf "carbon_check" "carbon_check" { } #If auto-select GUI, check for Carbon default=yes
      // edf "gtktest" "gtktest" { } #Do not try to compile and run a test GTK program
    */
      // edf "acl" "acl" { } #Don't check for ACL support.
      // edf "gpm" "gpm" { } #Don't use gpm (Linux mouse daemon).
      // edf "nls" "nls" { } #Don't support NLS (gettext()).
    ; 

  optionals = ["python"];

  extraAttrs = co : {
    name = "vim_configurable-7.1";

  src = args.fetchurl {
    url = ftp://ftp.nluug.nl/pub/editors/vim/unix/vim-7.1.tar.bz2;
    sha256 = "0w6gy49gdbw7hby5rjkjpa7cdvc0z5iajsm4j1h8108rvfam22kz";
  };

  postInstall = "
    rpath=`patchelf --print-rpath \$out/bin/vim`;
    for i in $\buildInputs; do
      echo adding \$i/lib
      rpath=\$rpath:\$i/lib
    done
    echo \$buildInputs
    echo \$rpath
    patchelf --set-rpath \$rpath \$out/bin/{vim,gvim}
  ";

  meta = {
    description = "The most popular clone of the VI editor";
    homepage = "www.vim.org";
  };
};
} ) args
