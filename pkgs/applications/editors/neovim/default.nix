{ stdenv, fetchFromGitHub, cmake, gettext, msgpack, libtermkey, libiconv
, libuv, luaPackages, ncurses, pkgconfig
, unibilium, xsel, gperf
, libvterm-neovim
, withJemalloc ? true, jemalloc
, glibcLocales ? null, procps ? null
, withDev ? true
, doCheck ? false
, lua
, python
}:

with stdenv.lib;

let
  neovimLuaEnv = lua.withPackages(ps:
    (with ps; [ mpack lpeg luabitop ]
    ++ optionals doCheck [ nvim-client luv coxpcall busted luafilesystem penlight  ]
    ++ optionals withDev [ luacheck ]
    ));
in
  stdenv.mkDerivation rec {
    name = "neovim-unwrapped-${version}";
    version = "0.3.4";

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${version}";
      sha256 = "07ncvgp6xfhiwc6hd7qf7zk28n3yj47p26qj1ji29vqkwnk28y3s";
    };

    enableParallelBuilding = true;

    buildInputs = [
      libtermkey
      libuv
      msgpack
      ncurses
      libvterm-neovim
      unibilium
      gperf
      neovimLuaEnv
    ] ++ optional withJemalloc jemalloc
      ++ optional stdenv.isDarwin libiconv
      ++ optionals doCheck [ glibcLocales procps ]
    ;

    inherit doCheck;

    # to be exhaustive, one could run
    # make oldtests too
    checkPhase = ''
      make functionaltest
    '';

    nativeBuildInputs = [
      cmake
      gettext
      pkgconfig
    ]
      ++ optional withDev python
    ;

    cmakeFlags = [
      "-DLUA_PRG=${neovimLuaEnv}/bin/lua"
      "-DGPERF_PRG=${gperf}/bin/gperf"
      "-DUNIBILIUM_LIBRARY=${unibilium}/lib/libunibilium${stdenv.targetPlatform.extensions.sharedLibrary}"
    ]
    # for now don't support luajit
    ++ optional (true) "-DPREFER_LUA=ON"
    ++ optional doCheck "-DBUSTED_PRG=${neovimLuaEnv}/bin/busted"
    ;

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

    # export PATH=$PWD/build/bin:${PATH}
    shellHook=''
      export VIMRUNTIME=$PWD/runtime
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
  }
