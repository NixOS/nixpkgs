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
    version = "0.3.4";

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${version}";
      sha256 = "07ncvgp6xfhiwc6hd7qf7zk28n3yj47p26qj1ji29vqkwnk28y3s";
    };

    patches = [
      # introduce a system-wide rplugin.vim in addition to the user one
      # necessary so that nix can handle `UpdateRemotePlugins` for the plugins
      # it installs. See https://github.com/neovim/neovim/issues/9413.
      ./system_rplugin_manifest.patch
    ];

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

    # nvim --version output retains compilation flags and references to build tools
    postPatch = ''
      substituteInPlace src/nvim/version.c --replace NVIM_VERSION_CFLAGS "";
    '';
    # check that the above patching actually works
    disallowedReferences = [ stdenv.cc ];

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
      # `lua: bad light userdata pointer`
      # https://nix-cache.s3.amazonaws.com/log/9ahcb52905d9d417zsskjpc331iailpq-neovim-unwrapped-0.2.2.drv
      broken = stdenv.isAarch64;
    };
  };

in
  neovim
