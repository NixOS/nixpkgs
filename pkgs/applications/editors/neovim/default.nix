{ stdenv, fetchFromGitHub, cmake, gettext, glib, libmsgpack, libtermkey
, libtool, libuv, lpeg, lua, luajit, luaMessagePack, luabitop, ncurses, perl
, pkgconfig, unibilium, makeWrapper, vimUtils

, withPython ? true, pythonPackages, extraPythonPackages ? []
, withPython3 ? true, python3Packages, extraPython3Packages ? []
, withJemalloc ? true, jemalloc

, withPyGUI ? false
, vimAlias ? false
, configure ? null
}:

with stdenv.lib;

let

  # Note: this is NOT the libvterm already in nixpkgs, but some NIH silliness:
  neovimLibvterm = stdenv.mkDerivation rec {
    name = "neovim-libvterm-${version}";
    version = "2015-11-06";

    src = fetchFromGitHub {
      sha256 = "090pyf1n5asaw1m2l9bsbdv3zd753aq1plb0w0drbc2k43ds7k3g";
      rev = "a9c7c6fd20fa35e0ad3e0e98901ca12dfca9c25c";
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
    extraLibs = (
        if withPyGUI
          then [ pythonPackages.neovim_gui ]
          else [ pythonPackages.neovim ]
      ) ++ extraPythonPackages;
    ignoreCollisions = true;
  };

  python3Env = python3Packages.python.buildEnv.override {
    extraLibs = [ python3Packages.neovim ] ++ extraPython3Packages;
    ignoreCollisions = true;
  };

  neovim = stdenv.mkDerivation rec {
    name = "neovim-${version}";
    version = "0.1.2";

    src = fetchFromGitHub {
      sha256 = "128aznp2gj08bdz05ri8mqday7wcsy9yz7dw7vdgzk0pk23vjz89";
      rev = "v${version}";
      repo = "neovim";
      owner = "neovim";
    };

    enableParallelBuilding = true;

    buildInputs = [
      glib
      libtermkey
      libuv
      # For some reason, `luajit` has to be listed after `lua`. See
      # https://github.com/NixOS/nixpkgs/issues/14442
      lua
      luajit
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
      substituteInPlace src/nvim/CMakeLists.txt --replace "    util" ""
    '';

    postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      echo patching $out/bin/nvim
      install_name_tool -change libjemalloc.1.dylib \
                ${jemalloc}/lib/libjemalloc.1.dylib \
                $out/bin/nvim
    '' + optionalString withPython ''
      ln -s ${pythonEnv}/bin/python $out/bin/nvim-python
    '' + optionalString withPyGUI ''
      makeWrapper "${pythonEnv}/bin/pynvim" "$out/bin/pynvim" \
        --prefix PATH : "$out/bin"
    '' + optionalString withPython3 ''
      ln -s ${python3Env}/bin/python3 $out/bin/nvim-python3
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

in if (vimAlias == false && configure == null) then neovim else stdenv.mkDerivation {
  name = "neovim-${neovim.version}-configured";
  inherit (neovim) version;

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
