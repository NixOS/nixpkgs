{ lib, stdenv, fetchFromGitHub, cmake, gettext, msgpack, libtermkey, libiconv
, libuv, lua, ncurses, pkg-config
, unibilium, gperf
, libvterm-neovim
, tree-sitter
, CoreServices
, glibcLocales ? null, procps ? null

# now defaults to false because some tests can be flaky (clipboard etc), see
# also: https://github.com/neovim/neovim/issues/16233
, doCheck ? false
, nodejs ? null, fish ? null, python3 ? null
}:

with lib;

let
  neovimLuaEnv = lua.withPackages(ps:
    (with ps; [ lpeg luabitop mpack ]
    ++ optionals doCheck [
        nvim-client luv coxpcall busted luafilesystem penlight inspect
      ]
    ));

  pyEnv = python3.withPackages(ps: with ps; [ pynvim msgpack ]);
in
  stdenv.mkDerivation rec {
    pname = "neovim-unwrapped";
    version = "0.7.2";

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${version}";
      sha256 = "sha256-eKKQNM02Vhy+3yL2QV+0FSEpcniEa5Aq6hkAUIgLo1k=";
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
      msgpack
      ncurses
      neovimLuaEnv
      tree-sitter
      unibilium
    ] ++ optionals stdenv.isDarwin [ libiconv CoreServices ]
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
      pkg-config
    ];

    # extra programs test via `make functionaltest`
    checkInputs = [
      fish
      nodejs
      pyEnv      # for src/clint.py
    ];


    # nvim --version output retains compilation flags and references to build tools
    postPatch = ''
      substituteInPlace src/nvim/version.c --replace NVIM_VERSION_CFLAGS "";
    '';
    # check that the above patching actually works
    disallowedReferences = [ stdenv.cc ];

    cmakeFlags = [
      # Don't use downloaded dependencies. At the end of the configurePhase one
      # can spot that cmake says this option was "not used by the project".
      # That's because all dependencies were found and
      # third-party/CMakeLists.txt is not read at all.
      "-DUSE_BUNDLED=OFF"
    ]
    ++ optional (!lua.pkgs.isLuaJIT) "-DPREFER_LUA=ON"
    ;

    # triggers on buffer overflow bug while running tests
    hardeningDisable = [ "fortify" ];

    preConfigure = lib.optionalString stdenv.isDarwin ''
      substituteInPlace src/nvim/CMakeLists.txt --replace "    util" ""
    '';

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
