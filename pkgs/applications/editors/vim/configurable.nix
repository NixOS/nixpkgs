{ source ? "default", callPackage, lib, stdenv, ncurses, pkg-config, gettext
, writeText, config, glib, gtk2-x11, gtk3-x11, lua, python3, perl, tcl, ruby
, libX11, libXext, libSM, libXpm, libXt, libXaw, libXau, libXmu
, libICE
, vimPlugins
, makeWrapper
, wrapGAppsHook
, runtimeShell

# apple frameworks
, CoreServices, CoreData, Cocoa, Foundation, libobjc

, features          ? "huge" # One of tiny, small, normal, big or huge
, wrapPythonDrv     ? false
, guiSupport        ? config.vim.gui or (if stdenv.isDarwin then "gtk2" else "gtk3")
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

in stdenv.mkDerivation rec {

  pname = "vim-full";

  inherit (common) version postPatch hardeningDisable enableParallelBuilding meta;

  src = builtins.getAttr source {
    default = common.src; # latest release
  };

  patches = [ ./cflags-prune.diff ] ++ lib.optional ftNixSupport ./ft-nix-support.patch;

  configureFlags = [
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
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "vim_cv_toupper_broken=no"
    "--with-tlib=ncurses"
    "vim_cv_terminfo=yes"
    "vim_cv_tgetent=zero" # it does on native anyway
    "vim_cv_tty_group=tty"
    "vim_cv_tty_mode=0660"
    "vim_cv_getcwd_broken=no"
    "vim_cv_stat_ignores_slash=yes"
    "vim_cv_memmove_handles_overlap=yes"
  ]
    ++ lib.optional (guiSupport == "gtk2" || guiSupport == "gtk3") "--enable-gui=${guiSupport}"
  ++ lib.optional stdenv.isDarwin
     (if darwinSupport then "--enable-darwin" else "--disable-darwin")
  ++ lib.optionals luaSupport [
    "--with-lua-prefix=${lua}"
    "--enable-luainterp"
  ] ++ lib.optionals lua.pkgs.isLuaJIT [
    "--with-luajit"
  ]
  ++ lib.optionals pythonSupport [
    "--enable-python3interp=yes"
    "--with-python3-config-dir=${python3}/lib"
    # Disables Python 2
    "--disable-pythoninterp"
  ]
  ++ lib.optional nlsSupport          "--enable-nls"
  ++ lib.optional perlSupport         "--enable-perlinterp"
  ++ lib.optional rubySupport         "--enable-rubyinterp"
  ++ lib.optional tclSupport          "--enable-tclinterp"
  ++ lib.optional multibyteSupport    "--enable-multibyte"
  ++ lib.optional cscopeSupport       "--enable-cscope"
  ++ lib.optional netbeansSupport     "--enable-netbeans"
  ++ lib.optional ximSupport          "--enable-xim";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional wrapPythonDrv makeWrapper
  ++ lib.optional nlsSupport gettext
  ++ lib.optional perlSupport perl
  ++ lib.optional (guiSupport == "gtk3") wrapGAppsHook
  ;

  buildInputs = [
    ncurses
    glib
  ]
    # All X related dependencies
    ++ lib.optionals (guiSupport == "gtk2" || guiSupport == "gtk3") [
      libSM
      libICE
      libX11
      libXext
      libXpm
      libXt
      libXaw
      libXau
      libXmu
    ]
    ++ lib.optional (guiSupport == "gtk2") gtk2-x11
    ++ lib.optional (guiSupport == "gtk3") gtk3-x11
    ++ lib.optionals darwinSupport [ CoreServices CoreData Cocoa Foundation libobjc ]
    ++ lib.optional luaSupport lua
    ++ lib.optional pythonSupport python3
    ++ lib.optional tclSupport tcl
    ++ lib.optional rubySupport ruby;

  # error: '__declspec' attributes are not enabled; use '-fdeclspec' or '-fms-extensions' to enable support for __declspec attributes
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-fdeclspec";

  preConfigure = "" + lib.optionalString ftNixSupport ''
      cp ${vimPlugins.vim-nix.src}/ftplugin/nix.vim runtime/ftplugin/nix.vim
      cp ${vimPlugins.vim-nix.src}/indent/nix.vim runtime/indent/nix.vim
      cp ${vimPlugins.vim-nix.src}/syntax/nix.vim runtime/syntax/nix.vim
    '';

  preInstall = ''
    mkdir -p $out/share/applications $out/share/icons/{hicolor,locolor}/{16x16,32x32,48x48}/apps
  '';

  postInstall = ''
    ln -s $out/bin/vim $out/bin/vi
  '' + lib.optionalString stdenv.isLinux ''
    ln -sfn '${nixosRuntimepath}' "$out"/share/vim/vimrc
  '';

  postFixup = lib.optionalString wrapPythonDrv ''
    wrapProgram "$out/bin/vim" --prefix PATH : "${python3}/bin" \
      --set NIX_PYTHONPATH "${python3}/${python3.sitePackages}"
  '';

  dontStrip = true;
}
