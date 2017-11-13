{ stdenv, fetchFromGitHub, cmake, gettext, libmsgpack, libtermkey
, libtool, libuv, luajit, luajitPackages, luaPackages, ncurses, perl, pkgconfig
, unibilium, makeWrapper, vimUtils, xsel, gperf, callPackage

, withPython ? true, pythonPackages, extraPythonPackages ? []
, withPython3 ? true, python3Packages, extraPython3Packages ? []
, withJemalloc ? true, jemalloc
, withRuby ? true, bundlerEnv

, withPyGUI ? false
, vimAlias ? false
, configure ? null
}:

with stdenv.lib;

let

  # Note: this is NOT the libvterm already in nixpkgs, but some NIH silliness:
  neovimLibvterm = stdenv.mkDerivation rec {
    name = "neovim-libvterm-${version}";
    version = "2016-10-07";

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "libvterm";
      rev = "5a748f97fbf27003e141002b58933a99f3addf8d";
      sha256 = "1fnd57f5n9h7z50a4vj7g96k6ndsdknjqsibgnxi9ndhyz244qbx";
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
      maintainers = with maintainers; [ nckx garbas ];
      platforms = platforms.unix;
    };
  };

  neovim-gem = callPackage ./ruby_provider {};
  neovim-gem-bin =
    "${neovim-gem}/bin/neovim-ruby-host";

  rubyWrapper = ''--cmd \"let g:ruby_host_prog='${neovim-gem-bin}'\" '';

  pluginPythonPackages = if configure == null then [] else builtins.concatLists
    (map ({ pythonDependencies ? [], ...}: pythonDependencies)
         (vimUtils.requiredPlugins configure));
  pythonEnv = pythonPackages.python.buildEnv.override {
    extraLibs = (
        if withPyGUI
          then [ pythonPackages.neovim_gui ]
          else [ pythonPackages.neovim ]
      ) ++ extraPythonPackages ++ pluginPythonPackages;
    ignoreCollisions = true;
  };
  pythonWrapper = ''--cmd \"let g:python_host_prog='$out/bin/nvim-python'\" '';

  pluginPython3Packages = if configure == null then [] else builtins.concatLists
    (map ({ python3Dependencies ? [], ...}: python3Dependencies)
         (vimUtils.requiredPlugins configure));
  python3Env = python3Packages.python.buildEnv.override {
    extraLibs = [ python3Packages.neovim ] ++ extraPython3Packages ++ pluginPython3Packages;
    ignoreCollisions = true;
  };
  python3Wrapper = ''--cmd \"let g:python3_host_prog='$out/bin/nvim-python3'\" '';
  additionalFlags = optionalString (withPython || withPython3 || withRuby)
  ''--add-flags "${
    (optionalString withPython pythonWrapper) +
    (optionalString withPython3 python3Wrapper) +
    (optionalString withRuby rubyWrapper)
  }" --unset PYTHONPATH'';

  neovim = stdenv.mkDerivation rec {
    name = "neovim-${version}";
    version = "0.2.1";

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${version}";
      sha256 = "19ppj0i59kk70j09gap6azm0jm4y95fr5fx7n9gx377y3xjs8h03";
    };

    enableParallelBuilding = true;

    buildInputs = [
      libtermkey
      libuv
      libmsgpack
      ncurses
      neovimLibvterm
      unibilium
      luajit
      luaPackages.lua
      gperf
    ] ++ optional withJemalloc jemalloc
      ++ lualibs;

    nativeBuildInputs = [
      cmake
      gettext
      makeWrapper
      pkgconfig
    ];

    LUA_PATH = stdenv.lib.concatStringsSep ";" (map luaPackages.getLuaPath lualibs);
    LUA_CPATH = stdenv.lib.concatStringsSep ";" (map luaPackages.getLuaCPath lualibs);

    lualibs = [ luaPackages.mpack luaPackages.lpeg luajitPackages.lpeg luaPackages.luabitop ];

    cmakeFlags = [
      "-DLUA_PRG=${luaPackages.lua}/bin/lua"
    ];

    # triggers on buffer overflow bug while running tests
    hardeningDisable = [ "fortify" ];

    preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
      export DYLD_LIBRARY_PATH=${jemalloc}/lib
      substituteInPlace src/nvim/CMakeLists.txt --replace "    util" ""
    '';

    postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      echo patching $out/bin/nvim
      install_name_tool -change libjemalloc.1.dylib \
                ${jemalloc}/lib/libjemalloc.1.dylib \
                $out/bin/nvim
      sed -i -e "s|'xsel|'${xsel}/bin/xsel|" $out/share/nvim/runtime/autoload/provider/clipboard.vim
    '' + optionalString withPython ''
      ln -s ${pythonEnv}/bin/python $out/bin/nvim-python
    '' + optionalString withPyGUI ''
      makeWrapper "${pythonEnv}/bin/pynvim" "$out/bin/pynvim" \
        --prefix PATH : "$out/bin"
    '' + optionalString withPython3 ''
      ln -s ${python3Env}/bin/python3 $out/bin/nvim-python3
    '' + optionalString (withPython || withPython3 || withRuby) ''
      wrapProgram $out/bin/nvim ${additionalFlags}
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
      homepage    = https://www.neovim.io;
      # "Contributions committed before b17d96 by authors who did not sign the
      # Contributor License Agreement (CLA) remain under the Vim license.
      # Contributions committed after b17d96 are licensed under Apache 2.0 unless
      # those contributions were copied from Vim (identified in the commit logs
      # by the vim-patch token). See LICENSE for details."
      license = with licenses; [ asl20 vim ];
      maintainers = with maintainers; [ manveru garbas ];
      platforms   = platforms.unix;
    };
  };

in if (vimAlias == false && configure == null) then neovim else stdenv.mkDerivation {
  name = "neovim-${neovim.version}-configured";
  inherit (neovim) version meta;

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
