{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  libuv,
  lua5_1,
  luajit,
  pkg-config,
  unibilium,
  utf8proc,
  tree-sitter,
  fetchurl,
  buildPackages,
  treesitter-parsers ? import ./treesitter-parsers.nix { inherit fetchurl; },
  fixDarwinDylibNames,
  glibcLocales ? null,
  procps ? null,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,

  # now defaults to false because some tests can be flaky (clipboard etc), see
  # also: https://github.com/neovim/neovim/issues/16233
  nodejs ? null,
  fish ? null,
  python3 ? null,
}:

let
  lua = if lib.meta.availableOn stdenv.hostPlatform luajit then luajit else lua5_1;
in

stdenv.mkDerivation (
  finalAttrs:
  let
    nvim-lpeg-dylib =
      luapkgs:
      if stdenv.hostPlatform.isDarwin then
        let
          luaLibDir = "$out/lib/lua/${lib.versions.majorMinor luapkgs.lua.luaversion}";
        in
        (luapkgs.lpeg.overrideAttrs (old: {
          preConfigure = ''
            # neovim wants clang .dylib
            substituteInPlace Makefile \
              --replace-fail "CC = gcc" "CC = clang" \
              --replace-fail "-bundle" "-dynamiclib" \
              --replace-fail "lpeg.so" "lpeg.dylib"
          '';
          preBuild = ''
            # there seems to be implicit calls to Makefile from luarocks, we need to
            # add a stage to build our dylib
            make macosx
            mkdir -p ${luaLibDir}
            mv lpeg.dylib ${luaLibDir}/lpeg.dylib
          '';
          postInstall = ''
            rm -f ${luaLibDir}/lpeg.so
          '';
          nativeBuildInputs =
            old.nativeBuildInputs ++ (lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames);
        }))
      else
        luapkgs.lpeg;
    runtimeLuaPkgs = ps: [
      (nvim-lpeg-dylib ps)
      ps.luabitop
      ps.mpack
    ];
    checkLuaPkgs =
      ps:
      runtimeLuaPkgs ps
      ++ (with ps; [
        luv
        coxpcall
        busted
        luafilesystem
        penlight
        inspect
      ]);
    # neovimLuaEnv ends up in buildInputs and its lib path is baked into the
    # nvim binary, so it must only contain runtime modules; otherwise
    # busted -> luarocks -> cmake leak into the runtime closure.
    neovimLuaEnv = lua.withPackages runtimeLuaPkgs;
    neovimLuaEnvOnBuild = lua.luaOnBuild.withPackages (
      if finalAttrs.finalPackage.doCheck then checkLuaPkgs else runtimeLuaPkgs
    );
    codegenLua =
      if lua.luaOnBuild.pkgs.isLuaJIT then
        let
          deterministicLuajit = lua.luaOnBuild.override {
            deterministicStringIds = true;
            self = deterministicLuajit;
          };
        in
        deterministicLuajit.withPackages (ps: [
          ps.mpack
          (nvim-lpeg-dylib ps)
        ])
      else
        lua.luaOnBuild;

  in
  {
    pname = "neovim-unwrapped";
    version = "0.12.1";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      tag = "v${finalAttrs.version}";
      hash = "sha256-cbFM5TKGmhEDsdhMvGzMyn0Js0MJwdMwXDkzQcdw/TM=";
    };

    strictDeps = true;

    patches = [
      # introduce a system-wide rplugin.vim in addition to the user one
      # necessary so that nix can handle `UpdateRemotePlugins` for the plugins
      # it installs. See https://github.com/neovim/neovim/issues/9413.
      ./system_rplugin_manifest.patch
    ];

    inherit lua;
    treesitter-parsers =
      lib.mapAttrs
        (
          language: grammar:
          tree-sitter.buildGrammar {
            inherit (grammar) src;
            version = "neovim-${finalAttrs.version}";
            language = grammar.language or language;
            location = grammar.location or null;
          }
        )
        (
          treesitter-parsers

          // {
            markdown = treesitter-parsers.markdown // {
              location = "tree-sitter-markdown";
            };
          }
          // {
            markdown_inline = treesitter-parsers.markdown // {
              language = "markdown_inline";
              location = "tree-sitter-markdown-inline";
            };
          }
        );

    buildInputs = [
      libuv
      # This is actually a c library, hence it's not included in neovimLuaEnv,
      # see:
      # https://github.com/luarocks/luarocks/issues/1402#issuecomment-1080616570
      # and it's definition at: pkgs/development/lua-modules/overrides.nix
      lua.pkgs.libluv
      neovimLuaEnv
      tree-sitter
      unibilium
      utf8proc
    ]
    ++ lib.optionals (stdenv.hostPlatform.libc != "glibc") [
      # Provide libintl for non-glibc platforms
      gettext
    ];

    doCheck = true;

    # to be exhaustive, one could run
    # make oldtests too
    checkPhase = ''
      runHook preCheck
      make functionaltest__treesitter
      runHook postCheck
    '';

    nativeBuildInputs = [
      cmake
      gettext
      pkg-config
    ];

    # extra programs test via `make functionaltest`
    nativeCheckInputs =
      let
        pyEnv = python3.withPackages (
          ps: with ps; [
            pynvim
            msgpack
          ]
        );
      in
      [
        fish
        nodejs
        pyEnv # for src/clint.py
      ];

    # nvim --version output retains compilation flags and references to build tools
    postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      sed -i runtime/CMakeLists.txt \
        -e "s|\".*/bin/nvim|\${stdenv.hostPlatform.emulator buildPackages} &|g"
      sed -i src/nvim/po/CMakeLists.txt \
        -e "s|\$<TARGET_FILE:nvim|\${stdenv.hostPlatform.emulator buildPackages} &|g"
    '';
    # check that the above patching actually works
    disallowedRequisites = [
      stdenv.cc
    ]
    ++ lib.optional (lua != codegenLua) codegenLua
    # Ensure test-only lua modules (busted, ...) don't leak into the
    # runtime closure via LUA_PRG. When doCheck is off (and we're not
    # cross-compiling) the two envs are the same derivation, hence the
    # guard.
    ++ lib.optional (neovimLuaEnvOnBuild != neovimLuaEnv) neovimLuaEnvOnBuild;

    cmakeFlags = [
      # Don't use downloaded dependencies. At the end of the configurePhase one
      # can spot that cmake says this option was "not used by the project".
      # That's because all dependencies were found and
      # third-party/CMakeLists.txt is not read at all.
      (lib.cmakeBool "USE_BUNDLED" false)
      (lib.cmakeBool "ENABLE_TRANSLATIONS" true)
      (lib.cmakeBool "USE_BUNDLED_BUSTED" false)
    ]
    ++ (
      if lua.pkgs.isLuaJIT then
        [
          (lib.cmakeFeature "LUAC_PRG" "${lib.getExe' codegenLua "luajit"} -b -s %s -")
          (lib.cmakeFeature "LUA_GEN_PRG" (lib.getExe' codegenLua "luajit"))
          (lib.cmakeFeature "LUA_PRG" (lib.getExe' neovimLuaEnvOnBuild "luajit"))
        ]
      else
        [
          (lib.cmakeBool "PREFER_LUA" true)
        ]
    );

    preConfigure = ''
      mkdir -p $out/lib/nvim/parser
    ''
    + lib.concatStrings (
      lib.mapAttrsToList (language: grammar: ''
        ln -sf \
          ${grammar}/parser \
          $out/lib/nvim/parser/${language}.so
      '') finalAttrs.treesitter-parsers
    );

    shellHook = ''
      export VIMRUNTIME=$PWD/runtime
    '';

    separateDebugInfo = true;

    nativeInstallCheckInputs = [
      versionCheckHook
      lua.pkgs.busted
      writableTmpDirAsHomeHook
      glibcLocales

      # needs git for vim.pack tests as well
      procps
    ];
    versionCheckProgram = "${placeholder "out"}/bin/nvim";
    doInstallCheck = true;

    passthru = {
      updateScript = nix-update-script { };
    };

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
      homepage = "https://neovim.io";
      changelog = "https://github.com/neovim/neovim/releases/tag/${finalAttrs.src.tag}";
      mainProgram = "nvim";
      # "Contributions committed before b17d96 by authors who did not sign the
      # Contributor License Agreement (CLA) remain under the Vim license.
      # Contributions committed after b17d96 are licensed under Apache 2.0 unless
      # those contributions were copied from Vim (identified in the commit logs
      # by the vim-patch token). See LICENSE for details."
      license = with lib.licenses; [
        asl20
        vim
      ];
      teams = [ lib.teams.neovim ];
      platforms = lib.platforms.unix;
    };
  }
)
