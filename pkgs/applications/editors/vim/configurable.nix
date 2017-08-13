# TODO tidy up eg The patchelf code is patching gvim even if you don't build it..
# but I have gvim with python support now :) - Marc
args@{ source ? "default", callPackage, fetchurl, stdenv, ncurses, pkgconfig, gettext
, composableDerivation, writeText, lib, config, glib, gtk2, gtk3, python, perl, tcl, ruby
, libX11, libXext, libSM, libXpm, libXt, libXaw, libXau, libXmu
, libICE

# apple frameworks
, CoreServices, CoreData, Cocoa, Foundation, libobjc, cf-private

, ... }: with args;


let
  inherit (args.composableDerivation) composableDerivation edf;
  nixosRuntimepath = writeText "nixos-vimrc" ''
    set nocompatible
    syntax on

    function! NixosPluginPath()
      let seen = {}
      for p in reverse(split($NIX_PROFILES))
        for d in split(glob(p . '/share/vim-plugins/*'))
          let pluginname = substitute(d, ".*/", "", "")
          if !has_key(seen, pluginname)
            exec 'set runtimepath^='.d
            let after = d."/after"
            if isdirectory(after)
              exec 'set runtimepath^='.after
            endif
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

  common = callPackage ./common.nix {};
in
composableDerivation {
} (fix: rec {

    name = "vim_configurable-${version}";

    inherit (common) version postPatch hardeningDisable enableParallelBuilding meta;

    src = builtins.getAttr source {
      "default" = common.src; # latest release

      "vim-nox" =
          {
            # vim nox branch: client-server without X by uing sockets
            # REGION AUTO UPDATE: { name="vim-nox"; type="hg"; url="https://code.google.com/r/yukihironakadaira-vim-cmdsrv-nox/"; branch="cmdsrv-nox"; }
            src = (fetchurl { url = "http://mawercer.de/~nix/repos/vim-nox-hg-2082fc3.tar.bz2"; sha256 = "293164ca1df752b7f975fd3b44766f5a1db752de6c7385753f083499651bd13a"; });
            name = "vim-nox-hg-2082fc3";
            # END
          }.src;
      };

    patches = [ ./cflags-prune.diff ];

    configureFlags
      = [ "--enable-gui=${args.gui}" "--with-features=${args.features}" ];

    nativeBuildInputs = [ pkgconfig ];

    buildInputs
      = [ ncurses libX11 libXext libSM libXpm libXt libXaw libXau
          libXmu glib libICE ] ++ (if args.gui == "gtk3" then [gtk3] else [gtk2]);

    # most interpreters aren't tested yet.. (see python for example how to do it)
    flags = {
        ftNix = {
          patches = [ ./ft-nix-support.patch ];
        };
      }
      // edf {
        name = "darwin";
        enable = {
          buildInputs = [ CoreServices CoreData Cocoa Foundation libobjc cf-private ];
          NIX_LDFLAGS = stdenv.lib.optional stdenv.isDarwin
            "/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation";
        };
      } #Disable Darwin (macOS) support.
      // edf { name = "xsmp"; } #Disable XSMP session management
      // edf { name = "xsmp_interact"; } #Disable XSMP interaction
      // edf { name = "mzscheme"; feat = "mzschemeinterp";} #Include MzScheme interpreter.
      // edf { name = "perl"; feat = "perlinterp"; enable = { nativeBuildInputs = [perl]; };} #Include Perl interpreter.

      // edf {
        name = "python";
        feat = "python${if python ? isPy3 then "3" else ""}interp";
        enable = {
          buildInputs = [ python ];
        } // lib.optionalAttrs stdenv.isDarwin {
          configureFlags
            = [ "--enable-python${if python ? isPy3 then "3" else ""}interp=yes"
                "--with-python${if python ? isPy3 then "3" else ""}-config-dir=${python}/lib"
                "--disable-python${if python ? isPy3 then "" else "3"}interp" ];
        };
      }

      // edf { name = "tcl"; feat = "tclinterp"; enable = { buildInputs = [tcl]; }; } #Include Tcl interpreter.
      // edf { name = "ruby"; feat = "rubyinterp"; enable = { buildInputs = [ruby]; };} #Include Ruby interpreter.
      // edf {
        name = "lua";
        feat = "luainterp";
        enable = {
          buildInputs = [lua];
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
    cscopeSupport    = config.vim.cscope or true;
    netbeansSupport  = config.netbeans or true; # eg envim is using it
    ximSupport       = config.vim.xim or true; # less than 15KB, needed for deadkeys

    # by default, compile with darwin support if we're compiling on darwin, but
    # allow this to be disabled by setting config.vim.darwin to false
    darwinSupport    = stdenv.isDarwin && (config.vim.darwin or true);

    # add .nix filetype detection and minimal syntax highlighting support
    ftNixSupport     = config.vim.ftNix or true;
  };

  #--enable-gui=OPTS     X11 GUI default=auto OPTS=auto/no/gtk/gtk2/gtk3/gnome/gnome2/motif/athena/neXtaw/photon/carbon
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

  preInstall = ''
    mkdir -p $out/share/applications $out/share/icons/{hicolor,locolor}/{16x16,32x32,48x48}/apps
  '';

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    patchelf --set-rpath \
      "$(patchelf --print-rpath $out/bin/vim):${lib.makeLibraryPath buildInputs}" \
      "$out"/bin/{vim,gvim}

    ln -sfn '${nixosRuntimepath}' "$out"/share/vim/vimrc
  '';

  dontStrip = 1;
})
