{ lib, stdenv, fetchFromGitHub, removeReferencesTo, cmake, gettext, msgpack-c, libiconv
, libuv, lua, pkg-config
, unibilium
, libvterm-neovim
, tree-sitter
, fetchurl
, buildPackages
, treesitter-parsers ? import ./treesitter-parsers.nix { inherit fetchurl; }
, CoreServices
, fixDarwinDylibNames
, glibcLocales ? null, procps ? null

# now defaults to false because some tests can be flaky (clipboard etc), see
# also: https://github.com/neovim/neovim/issues/16233
, nodejs ? null, fish ? null, python3 ? null
}:
stdenv.mkDerivation (finalAttrs:
  let
  nvim-lpeg-dylib = luapkgs: if stdenv.hostPlatform.isDarwin
    then (luapkgs.lpeg.overrideAttrs (oa: {
      preConfigure = ''
        # neovim wants clang .dylib
        sed -i makefile -e "s/CC = gcc/CC = clang/"
        sed -i makefile -e "s/-bundle/-dynamiclib/"
      '';
      preBuild = ''
        # there seems to be implicit calls to Makefile from luarocks, we need to
        # add a stage to build our dylib
        make macosx
        mkdir -p $out/lib
        mv lpeg.so $out/lib/lpeg.dylib
      '';
      nativeBuildInputs =
        oa.nativeBuildInputs
        ++ (
          lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
        );
    }))
    else luapkgs.lpeg;
  requiredLuaPkgs = ps: (with ps; [
    (nvim-lpeg-dylib ps)
    luabitop
    mpack
  ] ++ lib.optionals finalAttrs.finalPackage.doCheck [
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
        in deterministicLuajit.withPackages(ps: [ ps.mpack (nvim-lpeg-dylib ps) ])
      else lua.luaOnBuild;


in {
    pname = "neovim-unwrapped";
    version = "0.10.1";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${finalAttrs.version}";
      hash = "sha256-OsHIacgorYnB/dPbzl1b6rYUzQdhTtsJYLsFLJxregk=";
    };

    patches = [
      # introduce a system-wide rplugin.vim in addition to the user one
      # necessary so that nix can handle `UpdateRemotePlugins` for the plugins
      # it installs. See https://github.com/neovim/neovim/issues/9413.
      ./system_rplugin_manifest.patch
    ];

    dontFixCmake = true;

    inherit lua;
    treesitter-parsers = treesitter-parsers //
      { markdown = treesitter-parsers.markdown // { location = "tree-sitter-markdown"; }; } //
      { markdown_inline = treesitter-parsers.markdown // { language = "markdown_inline"; location = "tree-sitter-markdown-inline"; }; }
      ;

    buildInputs = [
      libuv
      libvterm-neovim
      # This is actually a c library, hence it's not included in neovimLuaEnv,
      # see:
      # https://github.com/luarocks/luarocks/issues/1402#issuecomment-1080616570
      # and it's definition at: pkgs/development/lua-modules/overrides.nix
      lua.pkgs.libluv
      msgpack-c
      neovimLuaEnv
      tree-sitter
      unibilium
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv CoreServices ]
      ++ lib.optionals finalAttrs.finalPackage.doCheck [ glibcLocales procps ]
    ;

    doCheck = false;

    # to be exhaustive, one could run
    # make oldtests too
    checkPhase = ''
      runHook preCheck
      make functionaltest
      runHook postCheck
    '';

    nativeBuildInputs = [
      cmake
      gettext
      pkg-config
      removeReferencesTo
    ];

    # extra programs test via `make functionaltest`
    nativeCheckInputs = let
      pyEnv = python3.withPackages(ps: with ps; [ pynvim msgpack ]);
    in [
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
    postInstall = ''
      find "$out" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
    '';
    # check that the above patching actually works
    outputChecks = let
      disallowedRequisites = [ stdenv.cc ] ++ lib.optional (lua != codegenLua) codegenLua;
    in {
      out = { inherit disallowedRequisites; };
      debug = { inherit disallowedRequisites; };
    };

    cmakeFlags = [
      # Don't use downloaded dependencies. At the end of the configurePhase one
      # can spot that cmake says this option was "not used by the project".
      # That's because all dependencies were found and
      # third-party/CMakeLists.txt is not read at all.
      "-DUSE_BUNDLED=OFF"
    ]
    ++ lib.optional (!lua.pkgs.isLuaJIT) "-DPREFER_LUA=ON"
    ++ lib.optionals lua.pkgs.isLuaJIT [
      "-DLUAC_PRG=${codegenLua}/bin/luajit -b -s %s -"
      "-DLUA_GEN_PRG=${codegenLua}/bin/luajit"
      "-DLUA_PRG=${neovimLuaEnvOnBuild}/bin/luajit"
    ];

    preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/nvim/CMakeLists.txt --replace "    util" ""
    '' + ''
      mkdir -p $out/lib/nvim/parser
    '' + lib.concatStrings (lib.mapAttrsToList
      (language: grammar: ''
        ln -s \
          ${tree-sitter.buildGrammar {
            inherit (grammar) src;
            version = "neovim-${finalAttrs.version}";
            language = grammar.language or language;
            location = grammar.location or null;
          }}/parser \
          $out/lib/nvim/parser/${language}.so
      '')
      finalAttrs.treesitter-parsers);

    shellHook=''
      export VIMRUNTIME=$PWD/runtime
    '';

    separateDebugInfo = true;

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
      homepage    = "https://www.neovim.io";
      mainProgram = "nvim";
      # "Contributions committed before b17d96 by authors who did not sign the
      # Contributor License Agreement (CLA) remain under the Vim license.
      # Contributions committed after b17d96 are licensed under Apache 2.0 unless
      # those contributions were copied from Vim (identified in the commit logs
      # by the vim-patch token). See LICENSE for details."
      license = with lib.licenses; [ asl20 vim ];
      maintainers = with lib.maintainers; [ manveru rvolosatovs ];
      platforms   = lib.platforms.unix;
    };
  })
