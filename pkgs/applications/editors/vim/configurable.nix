# TODO tidy up eg The patchelf code is patching gvim even if you don't build it..
# but I have gvim with python support now :) - Marc
args@{pkgs, source ? "default", ...}: with args;


let inherit (args.composableDerivation) composableDerivation edf;
  nixosRuntimepath = pkgs.writeText "nixos-vimrc" ''
    set nocompatible
    syntax on

    function! NixosPluginPath()
      let seen = {}
      for p in reverse(split($NIX_PROFILES))
        for d in split(glob(p . '/share/vim-plugins/*'))
          let pluginname = substitute(d, ".*/", "", "")
          if !has_key(seen, pluginname)
            exec 'set runtimepath^='.d
            let seen[pluginname] = 1
          endif
        endfor
      endfor
    endfunction

    execute NixosPluginPath()

    if filereadable("/etc/vimrc")
      source /etc/vimrc
    elseif filereadable("/etc/vim/vimrc")
      source /etc/vim/vimrc
    endif
  '';
in
composableDerivation {
  # use gccApple to compile on darwin
  mkDerivation = ( if stdenv.isDarwin
                   then stdenvAdapters.overrideGCC stdenv gccApple
                   else stdenv ).mkDerivation;
} (fix: {

    name = "vim_configurable-7.4.335";

    enableParallelBuilding = true; # test this

    src =
      builtins.getAttr source {
      "default" =
        # latest release
      args.fetchhg {
            url = "https://vim.googlecode.com/hg/";
            rev = "v7-4-335";
            sha256 = "0qnpzfcbi6fhz82pj68l4vrnigca1akq2ksrxz6krwlfhns6jhhj";
      };

      "vim-nox" =
          {
            # vim nox branch: client-server without X by uing sockets
            # REGION AUTO UPDATE: { name="vim-nox"; type="hg"; url="https://code.google.com/r/yukihironakadaira-vim-cmdsrv-nox/"; branch="cmdsrv-nox"; }
            src = (fetchurl { url = "http://mawercer.de/~nix/repos/vim-nox-hg-2082fc3.tar.bz2"; sha256 = "293164ca1df752b7f975fd3b44766f5a1db752de6c7385753f083499651bd13a"; });
            name = "vim-nox-hg-2082fc3";
            # END
          }.src;
      };

    prePatch = "cd src";

    # if darwin support is enabled, we want to make sure we're not building with
    # OS-installed python framework
    patches = stdenv.lib.optionals
      (stdenv.isDarwin && (config.vim.darwin or true))
      [ ./python_framework.patch ];

    configureFlags
      = [ "--enable-gui=${args.gui}" "--with-features=${args.features}" ];

    nativeBuildInputs
      = [ ncurses pkgconfig gtk libX11 libXext libSM libXpm libXt libXaw libXau
          libXmu glib libICE ];

    # most interpreters aren't tested yet.. (see python for example how to do it)
    flags = {
        ftNix = {
          # because we cd to src in the main patch phase, we can't just add this
          # patch to the list, we have to apply it manually
          postPatch = ''
            cd ../runtime
            patch -p2 < ${./ft-nix-support.patch}
            cd ..
          '';
        };
      }
      // edf { name = "darwin"; } #Disable Darwin (Mac OS X) support.
      // edf { name = "xsmp"; } #Disable XSMP session management
      // edf { name = "xsmp_interact"; } #Disable XSMP interaction
      // edf { name = "mzscheme"; } #Include MzScheme interpreter.
      // edf { name = "perl"; feat = "perlinterp"; enable = { nativeBuildInputs = [perl]; };} #Include Perl interpreter.

      // edf {
        name = "python";
        feat = "pythoninterp";
        enable = {
          nativeBuildInputs = [ python ];
        } // lib.optionalAttrs stdenv.isDarwin {
          configureFlags
            = [ "--enable-pythoninterp=yes"
                "--with-python-config-dir=${python}/lib" ];
        };
      }

      // edf { name = "tcl"; enable = { nativeBuildInputs = [tcl]; }; } #Include Tcl interpreter.
      // edf { name = "ruby"; feat = "rubyinterp"; enable = { nativeBuildInputs = [ruby]; };} #Include Ruby interpreter.
      // edf {
        name = "lua";
        feat = "luainterp";
        enable = {
          nativeBuildInputs = [lua];
          configureFlags = [
            "--with-lua-prefix=${args.lua}"
            "--enable-luainterp"
          ];
        };
      }
      // edf { name = "cscope"; } #Include cscope interface.
      // edf { name = "workshop"; } #Include Sun Visual Workshop support.
      // edf { name = "netbeans"; } #Disable NetBeans integration support.
      // edf { name = "sniff"; feat = "sniff" ; } #Include Sniff interface.
      // edf { name = "multibyte"; } #Include multibyte editing support.
      // edf { name = "hangulinput"; feat = "hangulinput" ;} #Include Hangul input support.
      // edf { name = "xim"; } #Include XIM input support.
      // edf { name = "fontset"; } #Include X fontset output support.
      // edf { name = "acl"; } #Don't check for ACL support.
      // edf { name = "gpm"; } #Don't use gpm (Linux mouse daemon).
      // edf { name = "nls"; enable = {nativeBuildInputs = [gettext];}; } #Don't support NLS (gettext()).
      ;

  cfg = {
    luaSupport       = config.vim.lua or true;
    pythonSupport    = config.vim.python or true;
    rubySupport      = config.vim.ruby or true;
    nlsSupport       = config.vim.nls or false;
    tclSupport       = config.vim.tcl or false;
    multibyteSupport = config.vim.multibyte or false;
    cscopeSupport    = config.vim.cscope or false;
    netbeansSupport  = config.netbeans or true; # eg envim is using it

    # by default, compile with darwin support if we're compiling on darwin, but
    # allow this to be disabled by setting config.vim.darwin to false
    darwinSupport    = stdenv.isDarwin && (config.vim.darwin or true);

    # add .nix filetype detection and minimal syntax highlighting support
    ftNixSupport     = config.vim.ftNix or true;
  };

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

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    rpath=`patchelf --print-rpath $out/bin/vim`;
    for i in $nativeBuildInputs; do
      echo adding $i/lib
      rpath=$rpath:$i/lib
    done
    echo $nativeBuildInputs
    echo $rpath
    patchelf --set-rpath $rpath $out/bin/{vim,gvim}

    ln -sfn ${nixosRuntimepath} $out/share/vim/vimrc
  '';

  dontStrip = 1;

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
})

