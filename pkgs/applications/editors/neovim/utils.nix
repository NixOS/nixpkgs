{ lib
, callPackage
, vimUtils
, nodejs
, neovim-unwrapped
, bundlerEnv
, ruby
, lua
, python3Packages
, wrapNeovimUnstable
, runCommand
}:
let
  inherit (vimUtils) toVimPlugin;

  /* transform all plugins into an attrset
   { optional = bool; plugin = package; }
  */
  normalizePlugins = plugins:
      let
        defaultPlugin = {
          plugin = null;
          config = null;
          optional = false;
        };
      in
        map (x: defaultPlugin // (if (x ? plugin) then x else { plugin = x; })) plugins;


  /* accepts a list of normalized plugins and convert themn
  */
  normalizedPluginsToVimPackage = normalizedPlugins:
    let
      pluginsPartitioned = lib.partition (x: x.optional == true) normalizedPlugins;
    in {
        start = map (x: x.plugin) pluginsPartitioned.wrong;
        opt = map (x: x.plugin) pluginsPartitioned.right;
      };

   /* returns everything needed for the caller to wrap its own neovim:
   - the generated content of the future init.vim
   - the arguments to wrap neovim with
   The caller is responsible for writing the init.vim and adding it to the wrapped
   arguments (["-u" writeText "init.vim" GENERATEDRC)]).
   This makes it possible to write the config anywhere: on a per-project basis
   .nvimrc or in $XDG_CONFIG_HOME/nvim/init.vim to avoid sideeffects.
   Indeed, note that wrapping with `-u init.vim` has sideeffects like .nvimrc wont be loaded
   anymore, $MYVIMRC wont be set etc
   */
   makeNeovimConfig = {
      customRC ? ""
      /* the function you would have passed to lua.withPackages */
      , extraLuaPackages ? (_: [ ])
      , ...}@attrs: let
        luaEnv = neovim-unwrapped.lua.withPackages extraLuaPackages;
     in attrs // {
     neovimRcContent = customRC;
     wrapperArgs = lib.optionals (luaEnv != null) [
          "--prefix" "LUA_PATH" ";" (neovim-unwrapped.lua.pkgs.luaLib.genLuaPathAbsStr luaEnv)
          "--prefix" "LUA_CPATH" ";" (neovim-unwrapped.lua.pkgs.luaLib.genLuaCPathAbsStr luaEnv)
      ];
   };


  # to keep backwards compatibility for people using neovim.override
  legacyWrapper = neovim: {
    extraMakeWrapperArgs ? ""
    /* the function you would have passed to python.withPackages */
    , extraPythonPackages ? (_: [])
    /* the function you would have passed to python.withPackages */
    , withPython3 ? true,  extraPython3Packages ? (_: [])
    /* the function you would have passed to lua.withPackages */
    , extraLuaPackages ? (_: [])
    , withNodeJs ? false
    , withRuby ? true
    , vimAlias ? false
    , viAlias ? false
    , configure ? {}
    , extraName ? ""
  }:
    let

      # we convert from the old configure.format to
      plugins = if builtins.hasAttr "plug" configure then
          throw "The neovim legacy wrapper doesn't support configure.plug anymore, please setup your plugins via 'configure.packages' instead"
        else
          lib.flatten (lib.mapAttrsToList genPlugin (configure.packages or {}));
      genPlugin = packageName: {start ? [], opt ? []}:
        start ++ (map (p: { plugin = p; optional = true; }) opt);

      res = makeNeovimConfig {
        inherit withPython3;
        inherit extraPython3Packages;
        inherit extraLuaPackages;
        inherit withNodeJs withRuby viAlias vimAlias;
        customRC = configure.customRC or "";
        inherit plugins;
        inherit extraName;
      };
    in
    wrapNeovimUnstable neovim (res // {
      wrapperArgs = lib.escapeShellArgs res.wrapperArgs + " " + extraMakeWrapperArgs;
      wrapRc = (configure != {});
  });

  /* Generate vim.g.<LANG>_host_prog lua rc to setup host providers

  Mapping a boolean argument to a key that tells us whether to add
      vim.g.<LANG>_host_prog=$out/bin/nvim-<LANG>
  Or this:
      let g:loaded_${prog}_provider=0
  While the latter tells nvim that this provider is not available */
  generateProviderRc = {
      withPython3 ? true
    , withNodeJs ? false
    , withRuby ? true
    # perl is problematic https://github.com/NixOS/nixpkgs/issues/132368
    , withPerl ? false

    # so that we can pass the full neovim config while ignoring it
    , ...
    }: let
      hostprog_check_table = {
        node = withNodeJs;
        python = false;
        python3 = withPython3;
        ruby = withRuby;
        perl = withPerl;
      };

      genProviderCommand = prog: withProg:
        if withProg then
          "vim.g.${prog}_host_prog='${placeholder "out"}/bin/nvim-${prog}'"
        else
          "vim.g.loaded_${prog}_provider=0";

      hostProviderLua = lib.mapAttrsToList genProviderCommand hostprog_check_table;
    in
        lib.concatStringsSep ";" hostProviderLua;

  /* Converts a lua package into a neovim plugin.
    Does so by installing the lua package with a flat hierarchy of folders
  */
  buildNeovimPlugin = callPackage ./build-neovim-plugin.nix {
    inherit (vimUtils) toVimPlugin;
    inherit lua;
  };

  grammarToPlugin = grammar:
    let
      name = lib.pipe grammar [
        lib.getName

        # added in buildGrammar
        (lib.removeSuffix "-grammar")

        # grammars from tree-sitter.builtGrammars
        (lib.removePrefix "tree-sitter-")
        (lib.replaceStrings [ "-" ] [ "_" ])
      ];
    in

    toVimPlugin (runCommand "treesitter-grammar-${name}"
      {
        meta = {
          platforms = lib.platforms.all;
        } // grammar.meta;
      }
      ''
        mkdir -p "$out/parser"
        ln -s "${grammar}/parser" "$out/parser/${name}.so"

        mkdir -p "$out/queries/${name}"
        if [ -d "${grammar}/queries/${name}" ]; then
          echo "moving queries from neovim queries dir"
          for file in "${grammar}/queries/${name}"*; do
            ln -s "$file" "$out/queries/${name}/$(basename "$file")"
          done
        else
          if [ -d "${grammar}/queries" ]; then
            echo "moving queries from standard queries dir"
            for file in "${grammar}/queries/"*; do
              ln -s "$file" "$out/queries/${name}/$(basename "$file")"
            done
          else
            echo "missing queries for ${name}"
          fi
        fi
      '');

  /*
    Fork of vimUtils.packDir that additionnally generates a propagated-build-inputs-file that
    can be used by the lua hooks to generate a proper LUA_PATH

    Generates a packpath folder as expected by vim
       Example:
       packDir ( {myVimPackage = { start = [ vimPlugins.vim-fugitive ]; opt = []; }; })
       => "/nix/store/xxxxx-pack-dir"
  */
  packDir = packages:
  let
    rawPackDir = vimUtils.packDir packages;

  in
    rawPackDir.override ({
    postBuild = ''
      mkdir $out/nix-support
      for i in $(find -L $out -name propagated-build-inputs ); do
        cat "$i" >> $out/nix-support/propagated-build-inputs
      done
      '';});


in
{
  inherit makeNeovimConfig;
  inherit generateProviderRc;
  inherit legacyWrapper;
  inherit grammarToPlugin;
  inherit packDir;
  inherit normalizePlugins normalizedPluginsToVimPackage;

  inherit buildNeovimPlugin;
  buildNeovimPluginFrom2Nix = lib.warn "buildNeovimPluginFrom2Nix was renamed to buildNeovimPlugin" buildNeovimPlugin;
}
