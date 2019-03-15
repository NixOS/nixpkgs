{ lib, config, vimUtils, haskellPackages, pythonPackages, python3Packages,
nodePackages, bundlerEnv, ruby, ... }:

with lib;
let
  /* for compatibility with passing extraPythonPackages as a list; added 2018-07-11 */
  compatFun = funOrList: (if builtins.isList funOrList then
    (_: lib.warn "passing a list as extraPythonPackages to the neovim wrapper is deprecated, pass a function as to python.withPackages instead" funOrList)
    else funOrList);

  buildHaskellEnv = locs: defs: haskellPackages.ghcWithPackages(ps: [ ps.nvim-hs ps.nvim-hs-ghcid]);

  buildRubyEnv = locs: defs:
    bundlerEnv {
      name = "neovim-ruby-env";
      gemdir = ./ruby_provider;
      postBuild = ''
        ln -sf ${ruby}/bin/* $out/bin
      '';
    };

  vimRC = vimUtils.vimrcContent (config.configure // {
    inherit (config) customRC;
  });

  buildPython3Env = let
      pluginPython3Packages = getDeps "python3Dependencies" (requiredPlugins config);
    in
      locs: defs:
      python3Packages.python.withPackages (ps:
              [ ps.pynvim ]
              ++ (config.extraPython3Packages ps)
              ++ (concatMap (f: f ps) pluginPython3Packages)
              );

    createPythonEnv = let
      pluginPythonPackages = getDeps "pythonDependencies" (requiredPlugins config);
    in
      locs: defs:
        pythonPackages.python.withPackages(ps:
          [ ps.pynvim ]
          ++ (config.extraPythonPackages ps)
          ++ (concatMap (f: f ps) pluginPythonPackages)
          );


  generatedNeovimRC = locs: defs:
        (concatStringsSep "\n" (getValues defs)) +
    ''
      ${if config.withNodeJs then "let g:node_host_prog='${nodePackages.neovim}/bin/neovim-node-host'" else "let g:loaded_node_provider=1"}
      ${if config.withPython then "let g:python_host_prog='${config.pythonEnv}/bin/python'" else "let g:loaded_python_provider=1"}
      ${if config.withPython3 then "let g:python3_host_prog='${config.python3Env}/bin/python'" else "let g:loaded_python3_provider=1"}
      ${if config.withRuby then "let g:ruby_host_prog='${config.rubyEnv}/bin/ruby'" else "let g:loaded_ruby_provider=1"}
      ${if config.withHaskell then "let g:haskell_host_prog='${config.haskellEnv}/bin/ghc'" else "let g:loaded_haskell_provider=1"}
    ''
    + optionalString config.withHaskell ''
      " start haskell host if required  {{{
      if has('nvim')
        function! s:RequireHaskellHost(name)
            return jobstart([ '${config.haskellEnv}/bin/nvim-hs', a:name.name], {'rpc': v:true, 'cwd': stdpath('config') })
        endfunction
      call remote#host#Register('haskell', "*.l\?hs", function('s:RequireHaskellHost'))
      endif
    "}}}
    ''
    # config. ?
    + vimRC
    ;

  extraPythonPackageType = mkOptionType {
    name = "extra-python-packages";
    description = "python packages in python.withPackages format";
    check = with types; (x: if isFunction x
      then isList (x pkgs.pythonPackages)
      else false);
    merge = mergeOneOption;
  };

  extraPython3PackageType = mkOptionType {
    name = "extra-python3-packages";
    description = "python3 packages in python.withPackages format";
    check = with types; (x: if isFunction x
      then isList (x pkgs.python3Packages)
      else true);
    # merge = mergeOneOption;
    # this should work ??? why
    # merge = mergeDefaultOption;

    # needs to retun a new function that calls the over function
    merge = loc: defs:
      # returns a function that passes the arg to a list
      x:
        foldr (a: b: a ++ b) []
        (map (f: f x) (getValues defs))
        ;
      # x: foldr (a: b:
      #   r: ( debug.traceVal(a) r) ++ ( debug.traceVal(b) r ))  # op
      #   (_: []) # nul
      #   (debug.traceValFn (x: "print values: ") (getValues defs));
      # x: foldr (a: b: ( debug.traceVal(a x)) ++ ( debug.traceVal ( b x ))) lib.id (getValues defs);
  };

  # original is
  # requiredPlugins = vimUtils.requiredPlugins configure;
  requiredPlugins = config: vimUtils.requiredPlugins (config.configure // {
    inherit (config) customRC;
  })
  ;

  getDeps = attrname: map (plugin: plugin.${attrname} or (_:[]));

in
{

  options = {

    viAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Symlink `vi` to `nvim` binary.
      '';
    };

    vimAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Symlink `vim` to `nvim` binary.
      '';
    };

    # kept to make the transition smoother
    configure = mkOption {
      type = types.attrs;
      default = {};
      example = literalExample ''
        configure = {
            customRC = $''''
            " here your custom configuration goes!
            $'''';
            packages.myVimPackage = with pkgs.vimPlugins; {
              # loaded on launch
              start = [ fugitive ];
              # manually loadable by calling `:packadd $plugin-name`
              opt = [ ];
            };
          };
      '';
      description = ''
        Legacy way of configuring (neo)vim. Still used for plugin manager specific configuration.
        See <link xlink:href='https://nixos.wiki/wiki/Vim'>the wiki</link>.
      '';
    };

    withNodeJs = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable node provider. Set to <literal>true</literal> to
        use Node plugins.
      '';
    };

    withHaskell = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable haskell provider nvim-hs. Set to <literal>true</literal> to
        use haskell plugins.
      '';
    };

    withPython = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable Python 2 provider. Set to <literal>true</literal> to
        use Python 2 plugins.
      '';
    };

    haskellEnv = mkOption {
      type = types.package // { merge = buildHaskellEnv; };
      readOnly = true;
      description = ''
        Python 3 environment. Set to <literal>true</literal> to
        use Python 2 plugins.
      '';
    };

    rubyEnv = mkOption {
      type = types.nullOr types.package // { merge = buildRubyEnv; };
      default = null;
      description = ''
        Read-only Ruby environment.
      '';
    };

    # provide a good default
    python3Env = mkOption {
      type = types.nullOr types.package // { merge = buildPython3Env; };
      default = null;
      description = ''
        Read only Python 3 environment.
      '';
    };

    pythonEnv = mkOption {
      type = types.nullOr types.package // { merge = createPythonEnv; };
      # readOnly = true;
      default = null;
      description = ''
        Read only Python 2 environment.
      '';
    };

    extraPythonPackages = mkOption {
      type = with types; either extraPythonPackageType (listOf package);
      default = (_: []);
      defaultText = "ps: []";
      example = literalExample "(ps: with ps; [ pandas jedi ])";
      description = ''
        A function in python.withPackages format, which returns a
        list of Python 2 packages required for your plugins to work.
      '';
    };

    withRuby = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable ruby provider.
      '';
    };

    # vimRC = mkOption {
    #   # readOnly = true;
    #   type = types.lines;
    #   default = "";
    #   description = ''
    #     The content of the vimrc generated from the other parameters.
    #   '';
    # };

    # alias it to init.file
    neovimRC = mkOption {
      # readOnly = true;
      # check = x: true;
      # why is it called twice ?
      type = types.lines // { merge = builtins.trace "gen" generatedNeovimRC; };
      default = "";
      description = ''
        The content of the init.vim generated from the other parameters.
      '';
    };

    withPython3 = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable Python 3 provider. Set to <literal>true</literal> to
        use Python 3 plugins.
      '';
    };

    extraPython3Packages = mkOption {
      type = with types; extraPython3PackageType;
      default = (_: []);
      defaultText = "ps: []";
      apply = compatFun;
      example = literalExample "(ps: with ps; [ python-language-server ])";
      description = ''
        A function in python.withPackages format, which returns a
        list of Python 3 packages required for your plugins to work.
      '';
    };

    customRC = mkOption {
      type = types.lines;
      example = literalExample ''
        set hidden
      }'';
      default = "";
      description = ''
        Structured kernel configuration.
      '';
    };
  };

  config = {
    # python3Env = let
    #   pluginPython3Packages = getDeps "python3Dependencies" (requiredPlugins config);
    # in
    #   python3Packages.python.withPackages (ps:
    #           [ ps.pynvim ]
    #           ++ (config.extraPython3Packages ps)
    #           # ++ debug.traceVal (config.extraPython3Packages ps)
    #           ++ (concatMap (f: f ps) pluginPython3Packages)
    #           );


    # haskellEnv = haskellPackages.ghcWithPackages(ps: [ ps.nvim-hs ps.nvim-hs-ghcid]);

    # neovimRC = generatedNeovimRC;

  };
}

