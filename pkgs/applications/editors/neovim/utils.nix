{
  lib,
  stdenv,
  makeSetupHook,
  callPackage,
  config,
  vimUtils,
  vimPlugins,
  nodejs,
  neovim-unwrapped,
  bundlerEnv,
  ruby,
  lua,
  python3Packages,
  wrapNeovimUnstable,
}:
let
  inherit (vimUtils) toVimPlugin;

  /*
    transform all plugins into an attrset
    { optional = bool; plugin = package; }
  */
  normalizePlugins =
    plugins:
    let
      defaultPlugin = {
        plugin = null;
        config = null;
        optional = false;
      };
    in
    map (x: defaultPlugin // (if (x ? plugin) then x else { plugin = x; })) plugins;

  /**
    accepts a list of normalized plugins and convert them into a vim package

    # Type

    ```
    normalizedPluginsToVimPackage :: [AttrSet] -> AttrSet
    ```

    # Examples
    :::{.example}

    ```nix
    normalizedPluginsToVimPackage [ { plugin = vim-fugitive; optional = false'} ]
    => { start = [ vim-fugitive ]; opt = []; }
    :::
  */
  normalizedPluginsToVimPackage =
    normalizedPlugins:
    let
      pluginsPartitioned = lib.partition (x: x.optional == true) normalizedPlugins;
    in
    {
      start = map (x: x.plugin) pluginsPartitioned.wrong;
      opt = map (x: x.plugin) pluginsPartitioned.right;
    };

  /*
    returns everything needed for the caller to wrap its own neovim:
    - the generated content of the future init.vim
    - the arguments to wrap neovim with
    The caller is responsible for writing the init.vim and adding it to the wrapped
    arguments (["-u" writeText "init.vim" GENERATEDRC)]).
    This makes it possible to write the config anywhere: on a per-project basis
    .nvimrc or in $XDG_CONFIG_HOME/nvim/init.vim to avoid sideeffects.
    Indeed, note that wrapping with `-u init.vim` has sideeffects like .nvimrc wont be loaded
    anymore, $MYVIMRC wont be set etc
  */
  makeNeovimConfig =
    {
      customRC ? "",
      customLuaRC ? "",
      # the function you would have passed to lua.withPackages
      extraLuaPackages ? (_: [ ]),
      ...
    }@attrs:
    let
      luaEnv = neovim-unwrapped.lua.withPackages extraLuaPackages;
    in
    attrs
    // {
      neovimRcContent = customRC;
      luaRcContent =
        if attrs ? luaRcContent then
          lib.warn "makeNeovimConfig: luaRcContent parameter is deprecated. Please use customLuaRC instead." attrs.luaRcContent
        else
          customLuaRC;
      wrapperArgs = lib.optionals (luaEnv != null) [
        "--prefix"
        "LUA_PATH"
        ";"
        (neovim-unwrapped.lua.pkgs.luaLib.genLuaPathAbsStr luaEnv)
        "--prefix"
        "LUA_CPATH"
        ";"
        (neovim-unwrapped.lua.pkgs.luaLib.genLuaCPathAbsStr luaEnv)
      ];
    };

  # to keep backwards compatibility for people using neovim.override
  legacyWrapper =
    neovim:
    {
      extraMakeWrapperArgs ? "",
      # the function you would have passed to python.withPackages
      extraPythonPackages ? (_: [ ]),
      # the function you would have passed to python.withPackages
      withPython3 ? true,
      extraPython3Packages ? (_: [ ]),
      # the function you would have passed to lua.withPackages
      extraLuaPackages ? (_: [ ]),
      withNodeJs ? false,
      withRuby ? false,
      vimAlias ? false,
      viAlias ? false,
      configure ? { },
      extraName ? "",
    }:
    let

      # we convert from the old configure.format to
      plugins =
        if builtins.hasAttr "plug" configure then
          throw "The neovim legacy wrapper doesn't support configure.plug anymore, please setup your plugins via 'configure.packages' instead"
        else
          lib.flatten (lib.mapAttrsToList genPlugin (configure.packages or { }));
      genPlugin =
        packageName:
        {
          start ? [ ],
          opt ? [ ],
        }:
        start
        ++ (map (p: {
          plugin = p;
          optional = true;
        }) opt);

      res = makeNeovimConfig {
        inherit withPython3;
        inherit extraPython3Packages;
        inherit extraLuaPackages;
        inherit
          withNodeJs
          withRuby
          viAlias
          vimAlias
          ;
        customRC = configure.customRC or "";
        customLuaRC = configure.customLuaRC or "";
        inherit plugins;
        inherit extraName;
      };
    in
    wrapNeovimUnstable neovim (
      res
      // {
        wrapperArgs = lib.escapeShellArgs res.wrapperArgs + " " + extraMakeWrapperArgs;
        wrapRc = (configure != { });
      }
    );

  /*
    Generate vim.g.<LANG>_host_prog lua rc to setup host providers

    Mapping a boolean argument to a key that tells us whether to add
        vim.g.<LANG>_host_prog=$out/bin/nvim-<LANG>
    Or this:
        let g:loaded_${prog}_provider=0
    While the latter tells nvim that this provider is not available
  */
  generateProviderRc =
    {
      withPython3 ? true,
      withNodeJs ? false,
      withRuby ? true,
      # Perl is problematic https://github.com/NixOS/nixpkgs/issues/132368
      withPerl ? false,

      # so that we can pass the full neovim config while ignoring it
      ...
    }:
    let
      hostprog_check_table = {
        node = withNodeJs;
        python = false;
        python3 = withPython3;
        ruby = withRuby;
        perl = withPerl;
      };

      genProviderCommand =
        prog: withProg:
        if withProg then
          "vim.g.${prog}_host_prog='${placeholder "out"}/bin/nvim-${prog}'"
        else
          "vim.g.loaded_${prog}_provider=0";

      hostProviderLua = lib.mapAttrsToList genProviderCommand hostprog_check_table;
    in
    lib.concatStringsSep ";" hostProviderLua;

  /*
    Converts a lua package into a neovim plugin.
    Does so by installing the lua package with a flat hierarchy of folders
  */
  buildNeovimPlugin = callPackage ./build-neovim-plugin.nix {
    inherit (vimUtils) toVimPlugin;
    inherit lua;
  };

  grammarToPlugin =
    grammar:
    let
      name = lib.pipe grammar [
        lib.getName

        # added in buildGrammar
        (lib.removeSuffix "-grammar")

        # grammars from tree-sitter.builtGrammars
        (lib.removePrefix "tree-sitter-")
        (lib.replaceStrings [ "-" ] [ "_" ])
      ];

      nvimGrammars = lib.mapAttrsToList (
        name: value:
        value.origGrammar
          or (throw "additions to `pkgs.vimPlugins.nvim-treesitter.grammarPlugins` set should be passed through `pkgs.neovimUtils.grammarToPlugin` first")
      ) vimPlugins.nvim-treesitter.grammarPlugins;
      isNvimGrammar = x: builtins.elem x nvimGrammars;

      toNvimTreesitterGrammar = makeSetupHook {
        name = "to-nvim-treesitter-grammar";
      } ./to-nvim-treesitter-grammar.sh;
    in

    (toVimPlugin (
      stdenv.mkDerivation {
        name = "treesitter-grammar-${name}";

        origGrammar = grammar;
        grammarName = name;

        # Queries for nvim-treesitter's (not just tree-sitter's) officially
        # supported languages are bundled with nvim-treesitter
        # Queries from repositories for such languages are incompatible
        # with nvim's implementation of treesitter.
        #
        # We try our best effort to only include queries for niche languages
        # (there are grammars for them in nixpkgs, but they're in
        # `tree-sitter-grammars.tree-sitter-*`; `vimPlugins.nvim-treesitter-parsers.*`
        # only includes officially supported languages)
        #
        # To use grammar for a niche language, users usually do:
        #   packages.all.start = with final.vimPlugins; [
        #     (pkgs.neovimUtils.grammarToPlugin pkgs.tree-sitter-grammars.tree-sitter-LANG)
        #   ]
        #
        # See also https://github.com/NixOS/nixpkgs/pull/344849#issuecomment-2381447839
        installQueries = !isNvimGrammar grammar;

        dontUnpack = true;
        __structuredAttrs = true;

        nativeBuildInputs = [ toNvimTreesitterGrammar ];

        meta = {
          platforms = lib.platforms.all;
        }
        // grammar.meta;
      }
    ));

  /*
    Fork of vimUtils.packDir that additionally generates a propagated-build-inputs-file that
    can be used by the lua hooks to generate a proper LUA_PATH

    Generates a packpath folder as expected by vim
       Example:
       packDir ( {myVimPackage = { start = [ vimPlugins.vim-fugitive ]; opt = []; }; })
       => "/nix/store/xxxxx-pack-dir"
  */
  packDir =
    packages:
    let
      rawPackDir = vimUtils.packDir packages;

    in
    rawPackDir.override {
      postBuild = ''
        mkdir $out/nix-support
        for i in $(find -L $out -name propagated-build-inputs ); do
          cat "$i" >> $out/nix-support/propagated-build-inputs
        done
      '';
    };

in
{
  inherit makeNeovimConfig;
  inherit generateProviderRc;
  inherit legacyWrapper;
  inherit grammarToPlugin;
  inherit packDir;
  inherit normalizePlugins normalizedPluginsToVimPackage;

  inherit buildNeovimPlugin;
}
// lib.optionalAttrs config.allowAliases {
  buildNeovimPluginFrom2Nix = lib.warn "buildNeovimPluginFrom2Nix was renamed to buildNeovimPlugin" buildNeovimPlugin;
}
