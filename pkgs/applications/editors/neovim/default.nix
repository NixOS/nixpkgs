{ lib, stdenv, fetchFromGitHub, cmake, gettext, msgpack-c, libtermkey, libiconv
, libuv, lua, ncurses, pkg-config
, unibilium, gperf
, libvterm-neovim
, tree-sitter
, fetchurl
, buildPackages
, treesitter-parsers ? import ./treesitter-parsers.nix { inherit fetchurl; }
, CoreServices
, glibcLocales ? null, procps ? null

# now defaults to false because some tests can be flaky (clipboard etc), see
# also: https://github.com/neovim/neovim/issues/16233
, doCheck ? false
, nodejs ? null, fish ? null, python3 ? null
}:

let
  requiredLuaPkgs = ps: (with ps; [
    lpeg
    luabitop
    mpack
  ] ++ lib.optionals doCheck [
    nvim-client
    luv
    coxpcall
    busted
    luafilesystem
    penlight
    inspect
  ]
  );
  neovimLuaEnv = lua.withPackages requiredLuaPkgs;
  neovimLuaEnvOnBuild = lua.luaOnBuild.withPackages requiredLuaPkgs;
  codegenLua =
    if lua.luaOnBuild.pkgs.isLuaJIT
      then
        let deterministicLuajit =
          lua.luaOnBuild.override {
            deterministicStringIds = true;
            self = deterministicLuajit;
          };
        in deterministicLuajit.withPackages(ps: [ ps.mpack ps.lpeg ])
      else lua.luaOnBuild;

  pyEnv = python3.withPackages(ps: with ps; [ pynvim msgpack ]);
in
  stdenv.mkDerivation rec {
    pname = "neovim-unwrapped";
    version = "0.9.2";

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${version}";
      hash = "sha256-kKstlq1BzoBAy+gy9iL1auRViJ223cVpAt5X7pUWT1U=";
    };

    patches = [
      # introduce a system-wide rplugin.vim in addition to the user one
      # necessary so that nix can handle `UpdateRemotePlugins` for the plugins
      # it installs. See https://github.com/neovim/neovim/issues/9413.
      ./system_rplugin_manifest.patch
    ];

    dontFixCmake = true;

    inherit lua;

    buildInputs = [
      gperf
      libtermkey
      libuv
      libvterm-neovim
      # This is actually a c library, hence it's not included in neovimLuaEnv,
      # see:
      # https://github.com/luarocks/luarocks/issues/1402#issuecomment-1080616570
      # and it's definition at: pkgs/development/lua-modules/overrides.nix
      lua.pkgs.libluv
      msgpack-c
      ncurses
      neovimLuaEnv
      tree-sitter
      unibilium
    ] ++ lib.optionals stdenv.isDarwin [ libiconv CoreServices ]
      ++ lib.optionals doCheck [ glibcLocales procps ]
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
      pkg-config
    ];

    # extra programs test via `make functionaltest`
    nativeCheckInputs = [
      fish
      nodejs
      pyEnv      # for src/clint.py
    ];

    # nvim --version output retains compilation flags and references to build tools
    postPatch = ''
      substituteInPlace src/nvim/version.c --replace NVIM_VERSION_CFLAGS "";
    '' + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      sed -i runtime/CMakeLists.txt \
        -e "s|\".*/bin/nvim|\${stdenv.hostPlatform.emulator buildPackages} &|g"
      sed -i src/nvim/po/CMakeLists.txt \
        -e "s|\$<TARGET_FILE:nvim|\${stdenv.hostPlatform.emulator buildPackages} &|g"
    '';
    # check that the above patching actually works
    disallowedReferences = [ stdenv.cc ] ++ lib.optional (lua != codegenLua) codegenLua;

    cmakeFlags = [
      # Don't use downloaded dependencies. At the end of the configurePhase one
      # can spot that cmake says this option was "not used by the project".
      # That's because all dependencies were found and
      # third-party/CMakeLists.txt is not read at all.
      "-DUSE_BUNDLED=OFF"
    ]
    ++ lib.optional (!lua.pkgs.isLuaJIT) "-DPREFER_LUA=ON"
    ;

    preConfigure = lib.optionalString lua.pkgs.isLuaJIT ''
      cmakeFlagsArray+=(
        "-DLUAC_PRG=${codegenLua}/bin/luajit -b -s %s -"
        "-DLUA_GEN_PRG=${codegenLua}/bin/luajit"
        "-DLUA_PRG=${neovimLuaEnvOnBuild}/bin/luajit"
      )
    '' + lib.optionalString stdenv.isDarwin ''
      substituteInPlace src/nvim/CMakeLists.txt --replace "    util" ""
    '' + ''
      mkdir -p $out/lib/nvim/parser
    '' + lib.concatStrings (lib.mapAttrsToList
      (language: src: ''
        ln -s \
          ${tree-sitter.buildGrammar {
            inherit language src;
            version = "neovim-${version}";
          }}/parser \
          $out/lib/nvim/parser/${language}.so
      '')
      treesitter-parsers);

    shellHook=''
      export VIMRUNTIME=$PWD/runtime
    '';

    separateDebugInfo = true;

    meta = with lib; {
      description = "Vim text editor fork focused on extensibility and agility";
      longDescription = ''
        Neovim is a project that seeks to aggressively refactor Vim in order to:
        - Simplify maintenance and encourage contributions
        - Split the work between multiple developers
        - Enable the implementation of new/modern user interfaces without any
          modifications to the core source
        - Improve extensibility with a new plugin architecture
      '';
      homepage    = "https://www.neovim.io";
      mainProgram = "nvim";
      # "Contributions committed before b17d96 by authors who did not sign the
      # Contributor License Agreement (CLA) remain under the Vim license.
      # Contributions committed after b17d96 are licensed under Apache 2.0 unless
      # those contributions were copied from Vim (identified in the commit logs
      # by the vim-patch token). See LICENSE for details."
      license = with licenses; [ asl20 vim ];
      maintainers = with maintainers; [ manveru rvolosatovs ];
      platforms   = platforms.unix;
    };
  }
