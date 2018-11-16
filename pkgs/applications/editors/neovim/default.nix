{ stdenv, fetchFromGitHub, cmake, gettext, msgpack, libtermkey, libiconv
, libuv, luaPackages, ncurses, pkgconfig
, unibilium, xsel, gperf
, libvterm-neovim
, withJemalloc ? true, jemalloc
}:

with stdenv.lib;

let

  neovim = stdenv.mkDerivation rec {
    name = "neovim-unwrapped-${version}";
    version = "0.3.1";

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${version}";
      sha256 = "19jy9nr2ffscli6wsysqkdvqvh7sgkkwhzkw3yypfrvg4pj9rl56";
    };

    enableParallelBuilding = true;

    buildInputs = [
      libtermkey
      libuv
      msgpack
      ncurses
      libvterm-neovim
      unibilium
      luaPackages.lua
      gperf
    ] ++ optional withJemalloc jemalloc
      ++ optional stdenv.isDarwin libiconv
      ++ lualibs;

    nativeBuildInputs = [
      cmake
      gettext
      pkgconfig
    ];

    LUA_PATH = stdenv.lib.concatStringsSep ";" (map luaPackages.getLuaPath lualibs);
    LUA_CPATH = stdenv.lib.concatStringsSep ";" (map luaPackages.getLuaCPath lualibs);

    lualibs = [ luaPackages.mpack luaPackages.lpeg luaPackages.luabitop ];

    cmakeFlags = [
      "-DLUA_PRG=${luaPackages.lua}/bin/lua"
      "-DGPERF_PRG=${gperf}/bin/gperf"
    ];

    # triggers on buffer overflow bug while running tests
    hardeningDisable = [ "fortify" ];

    preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
      export DYLD_LIBRARY_PATH=${jemalloc}/lib
      substituteInPlace src/nvim/CMakeLists.txt --replace "    util" ""
    '';

    postInstall = stdenv.lib.optionalString stdenv.isLinux ''
      sed -i -e "s|'xsel|'${xsel}/bin/xsel|g" $out/share/nvim/runtime/autoload/provider/clipboard.vim
    '' + stdenv.lib.optionalString (withJemalloc && stdenv.isDarwin) ''
      install_name_tool -change libjemalloc.1.dylib \
                ${jemalloc}/lib/libjemalloc.1.dylib \
                $out/bin/nvim
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
      maintainers = with maintainers; [ manveru garbas rvolosatovs ];
      platforms   = platforms.unix;
    };
  };

in
  neovim
