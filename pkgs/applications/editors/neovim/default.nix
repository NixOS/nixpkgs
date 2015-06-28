{ stdenv, fetchFromGitHub, cmake, gettext, glib, libmsgpack, libtermkey
, libtool, libuv, lpeg, lua, luajit, luaMessagePack, luabitop, ncurses, perl
, pkgconfig, unibilium, makeWrapper, vimUtils

, withPython ? true, pythonPackages, extraPythonPackages ? []
, withPython3 ? true, python3Packages, extraPython3Packages ? []
, withJemalloc ? true, jemalloc

, vimAlias ? false
, configure ? null
}:

with stdenv.lib;

let

  version = "2015-06-09";

  # Note: this is NOT the libvterm already in nixpkgs, but some NIH silliness:
  neovimLibvterm = let version = "2015-02-23"; in stdenv.mkDerivation rec {
    name = "neovim-libvterm-${version}";

    src = fetchFromGitHub {
      sha256 = "0i2h74jrx4fy90sv57xj8g4lbjjg4nhrq2rv6rz576fmqfpllcc5";
      rev = "20ad1396c178c72873aeeb2870bd726f847acb70";
      repo = "libvterm";
      owner = "neovim";
    };

    buildInputs = [ perl ];
    nativeBuildInputs = [ libtool ];

    makeFlags = [ "PREFIX=$(out)" ]
      ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

    enableParallelBuilding = true;

    meta = {
      description = "VT220/xterm/ECMA-48 terminal emulator library";
      homepage = http://www.leonerd.org.uk/code/libvterm/;
      license = licenses.mit;
      maintainers = with maintainers; [ nckx ];
      platforms = platforms.unix;
    };
  };

  pythonEnv = pythonPackages.python.buildEnv.override {
    extraLibs = [ pythonPackages.neovim ] ++ extraPythonPackages;
    ignoreCollisions = true;
  };

  python3Env = python3Packages.python.buildEnv.override {
    extraLibs = [ python3Packages.neovim ] ++ extraPython3Packages;
    ignoreCollisions = true;
  };

  neovim = stdenv.mkDerivation rec {
    name = "neovim-${version}";

    src = fetchFromGitHub {
      sha256 = "1lycql0lwi7ynrsaln4kxybwvxb9fvganiq3ba4pnpcfgl155k1j";
      rev = "6270d431aaeed71e7a8782411f36409ab8e0ee35";
      repo = "neovim";
      owner = "neovim";
    };

    enableParallelBuilding = true;

    buildInputs = [
      glib
      libtermkey
      libuv
      luajit
      lua
      lpeg
      luaMessagePack
      luabitop
      libmsgpack
      ncurses
      neovimLibvterm
      unibilium
    ] ++ optional withJemalloc jemalloc;

    nativeBuildInputs = [
      cmake
      gettext
      makeWrapper
      pkgconfig
    ];

    LUA_CPATH="${lpeg}/lib/lua/${lua.luaversion}/?.so;${luabitop}/lib/lua/5.2/?.so";
    LUA_PATH="${luaMessagePack}/share/lua/5.1/?.lua";

    preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
      export DYLD_LIBRARY_PATH=${jemalloc}/lib
    '';

    postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      echo patching $out/bin/nvim
      install_name_tool -change libjemalloc.1.dylib \
                ${jemalloc}/lib/libjemalloc.1.dylib \
                $out/bin/nvim
    '' + optionalString withPython ''
      ln -s ${pythonEnv}/bin/python $out/bin/nvim-python
    '' + optionalString withPython3 ''
      ln -s ${python3Env}/bin/python $out/bin/nvim-python3
    '' + optionalString (withPython || withPython3) ''
        wrapProgram $out/bin/nvim --add-flags "${
          (optionalString withPython
            ''--cmd \"let g:python_host_prog='$out/bin/nvim-python'\" '') +
          (optionalString withPython3
            ''--cmd \"let g:python3_host_prog='$out/bin/nvim-python3'\" '')
        }"
    '';

    meta = {
      description = "Vim text editor fork focused on extensibility and agility";
      longDescription = ''
        Neovim is a project that seeks to aggressively refactor Vim in order to:
        - Simplify maintenance and encourage contributions
        - Split the work between multiple developers
        - Enable the implementation of new/modern user interfaces without any
          modifications to the core source
        - Improve extensibility with a new plugin architecture
      '';
      homepage    = http://www.neovim.io;
      # "Contributions committed before b17d96 by authors who did not sign the
      # Contributor License Agreement (CLA) remain under the Vim license.
      # Contributions committed after b17d96 are licensed under Apache 2.0 unless
      # those contributions were copied from Vim (identified in the commit logs
      # by the vim-patch token). See LICENSE for details."
      license = with licenses; [ asl20 vim ];
      maintainers = with maintainers; [ manveru nckx garbas ];
      platforms   = platforms.unix;
    };
  };

in if (vimAlias == false && configure == null) then neovim else stdenv.mkDerivation rec {
  name = "neovim-${version}-configured";
  nativeBuildInputs = [ makeWrapper ];
  buildCommand = ''
    mkdir -p $out/bin
    for item in ${neovim}/bin/*; do
      ln -s $item $out/bin/
    done
  '' + optionalString vimAlias ''
    ln -s $out/bin/nvim $out/bin/vim
  '' + optionalString (configure != null) ''
    wrapProgram $out/bin/nvim --add-flags "-u ${vimUtils.vimrcFile configure}"
  '';
}
