# TODO tidy up eg The patchelf code is patching gvim even if you don't build it..
# but I have gvim with python support now :) - Marc
{ source ? "default", callPackage, fetchurl, stdenv, ncurses, pkgconfig, gettext
, writeText, config, glib, gtk2, gtk3, lua, python, perl, tcl, ruby
, libX11, libXext, libSM, libXpm, libXt, libXaw, libXau, libXmu
, libICE
, vimPlugins
, makeWrapper
, wrapGAppsHook

# apple frameworks
, CoreServices, CoreData, Cocoa, Foundation, libobjc, cf-private

, features          ? "huge" # One of tiny, small, normal, big or huge
, wrapPythonDrv     ? false
, guiSupport        ? config.vim.gui or "gtk3"
, luaSupport        ? config.vim.lua or true
, perlSupport       ? config.vim.perl or false      # Perl interpreter
, pythonSupport     ? config.vim.python or true     # Python interpreter
, rubySupport       ? config.vim.ruby or true       # Ruby interpreter
, nlsSupport        ? config.vim.nls or false       # Enable NLS (gettext())
, tclSupport        ? config.vim.tcl or false       # Include Tcl interpreter
, multibyteSupport  ? config.vim.multibyte or false # Enable multibyte editing support
, cscopeSupport     ? config.vim.cscope or true     # Enable cscope interface
, netbeansSupport   ? config.netbeans or true       # Enable NetBeans integration support.
, ximSupport        ? config.vim.xim or true        # less than 15KB, needed for deadkeys
, darwinSupport     ? config.vim.darwin or false    # Enable Darwin support
, ftNixSupport      ? config.vim.ftNix or true      # Add .nix filetype detection and minimal syntax highlighting support
, ...
}:


let
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

  isPython3 = python.isPy3 or false;

in stdenv.mkDerivation rec {

  name = "vim_configurable-${version}";

  inherit (common) version postPatch hardeningDisable enableParallelBuilding meta;

  src = builtins.getAttr source {
    "default" = common.src; # latest release
  };

  patches = [ ./cflags-prune.diff ] ++ stdenv.lib.optional ftNixSupport ./ft-nix-support.patch;

  configureFlags = [
    "--enable-gui=${guiSupport}"
    "--with-features=${features}"
    "--disable-xsmp"              # XSMP session management
    "--disable-xsmp_interact"     # XSMP interaction
    "--disable-workshop"          # Sun Visual Workshop support
    "--disable-sniff"             # Sniff interface
    "--disable-hangulinput"       # Hangul input support
    "--disable-fontset"           # X fontset output support
    "--disable-acl"               # ACL support
    "--disable-gpm"               # GPM (Linux mouse daemon)
    "--disable-mzschemeinterp"
    "--disable-gtk_check"
    "--disable-gtk2_check"
    "--disable-gnome_check"
    "--disable-motif_check"
    "--disable-athena_check"
    "--disable-nextaf_check"
    "--disable-carbon_check"
    "--disable-gtktest"
  ]
  ++ stdenv.lib.optional stdenv.isDarwin
     (if darwinSupport then "--enable-darwin" else "--disable-darwin")
  ++ stdenv.lib.optionals luaSupport [
    "--with-lua-prefix=${lua}"
    "--enable-luainterp"
  ]
  ++ stdenv.lib.optionals pythonSupport [
    "--enable-python${if isPython3 then "3" else ""}interp=yes"
    "--with-python${if isPython3 then "3" else ""}-config-dir=${python}/lib"
    "--disable-python${if (!isPython3) then "3" else ""}interp"
  ]
  ++ stdenv.lib.optional nlsSupport          "--enable-nls"
  ++ stdenv.lib.optional perlSupport         "--enable-perlinterp"
  ++ stdenv.lib.optional rubySupport         "--enable-rubyinterp"
  ++ stdenv.lib.optional tclSupport          "--enable-tclinterp"
  ++ stdenv.lib.optional multibyteSupport    "--enable-multibyte"
  ++ stdenv.lib.optional cscopeSupport       "--enable-cscope"
  ++ stdenv.lib.optional netbeansSupport     "--enable-netbeans"
  ++ stdenv.lib.optional ximSupport          "--enable-xim";

  nativeBuildInputs = [
    pkgconfig
  ]
  ++ stdenv.lib.optional wrapPythonDrv makeWrapper
  ++ stdenv.lib.optional nlsSupport gettext
  ++ stdenv.lib.optional perlSupport perl
  ++ stdenv.lib.optional (guiSupport == "gtk3") wrapGAppsHook
  ;

  buildInputs = [ ncurses libX11 libXext libSM libXpm libXt libXaw libXau
    libXmu glib libICE ]
    ++ stdenv.lib.optional (guiSupport == "gtk2") gtk2
    ++ stdenv.lib.optional (guiSupport == "gtk3") gtk3
    ++ stdenv.lib.optionals darwinSupport [ CoreServices CoreData Cocoa Foundation libobjc cf-private ]
    ++ stdenv.lib.optional luaSupport lua
    ++ stdenv.lib.optional pythonSupport python
    ++ stdenv.lib.optional tclSupport tcl
    ++ stdenv.lib.optional rubySupport ruby;

  preConfigure = ''
    '' + stdenv.lib.optionalString ftNixSupport ''
      cp ${vimPlugins.vim-nix.src}/ftplugin/nix.vim runtime/ftplugin/nix.vim
      cp ${vimPlugins.vim-nix.src}/indent/nix.vim runtime/indent/nix.vim
      cp ${vimPlugins.vim-nix.src}/syntax/nix.vim runtime/syntax/nix.vim
    '';

  postInstall = ''
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    patchelf --set-rpath \
      "$(patchelf --print-rpath $out/bin/vim):${stdenv.lib.makeLibraryPath buildInputs}" \
      "$out"/bin/{vim,gvim}

    ln -sfn '${nixosRuntimepath}' "$out"/share/vim/vimrc
  '' + stdenv.lib.optionalString wrapPythonDrv ''
    wrapProgram "$out/bin/vim" --prefix PATH : "${python}/bin"
  '' + stdenv.lib.optionalString (guiSupport == "gtk3") ''

    rewrap () {
      rm -f "$out/bin/$1"
      echo -e '#!${stdenv.shell}\n"'"$out/bin/vim"'" '"$2"' "$@"' > "$out/bin/$1"
      chmod a+x "$out/bin/$1"
    }

    rewrap ex -e	
    rewrap view -R	
    rewrap gvim -g	
    rewrap gex -eg	
    rewrap gview -Rg	
    rewrap rvim -Z	
    rewrap rview -RZ	
    rewrap rgvim -gZ	
    rewrap rgview -RgZ
    rewrap evim    -y
    rewrap eview   -yR
    rewrap vimdiff -d	
    rewrap gvimdiff -gd
  '';

  preInstall = ''
    mkdir -p $out/share/applications $out/share/icons/{hicolor,locolor}/{16x16,32x32,48x48}/apps
  '';

  dontStrip = 1;
}
