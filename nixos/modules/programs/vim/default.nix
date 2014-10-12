{ config, lib, pkgs, ... }:

with lib;

let
  modules = {
    general = import ./general.nix {inherit pkgs;};
    search = import ./search.nix {inherit pkgs;};
    completion = import ./completion.nix {inherit pkgs;};
    text = import ./text.nix {inherit pkgs;};
    sidebar = import ./sidebar.nix {inherit pkgs;};
    statusline = import ./statusline.nix {inherit pkgs;};
    haskell = import ./haskell.nix {inherit pkgs;};
  };
  defaultConfig = {
    #TODO: will overwrite all vim configurations :), so warn people about it first! enable = true;
    leader = " ";
    general.enable = true;
    statusline.enable = true;
    profiles =
      { hvim =
          { enable = true;
            exec = { package = pkgs.vim_configurable; bin = "bin/vim"; };
            search.enable = true;
            text.enable = true;
            sidebar.enable = true;
            completion.enable = true;
            haskell.enable = true;
          };
        hqvim =
          { enable = true;
            name = "Hvim";
            parent = "hvim";
            exec = { package = pkgs.qvim; bin = "bin/qvim"; };
          };
      };
  };
in
let
  #
  # options
  #
  optionsHelpers = rec {

    /*
     * The configuration is structured into profiles.
     * Each profile can activate individual modules and specify their settings.
     * One profile is marked as the default profile.
     * A non-default profile is created by specifying only the overwrites of the default profile.
     */


    # option flags that are added into each module
    moduleDefaults = dp:
      { enable = mkOption {
          type = if dp then types.bool else types.nullOr types.bool;
          default = if dp then false else null;
          description = "Enable/Disable flag for the module.";
        };
        leader = mkOption {
          type = types.nullOr types.string;
          default = null;
          description = ''Prefix key for all key bindings of the module.
                          If null, fall back to the leader defined for the profile.'';
        };
        vimrc = mkOption {
          type = if dp then types.string else types.nullOr types.string;
          default = if dp then "" else null;
          description = "Configuration to add into vimrc.";
        };
      };


    # Convert the stubs of a module definition into full options definitions.
    # Also, add the default attributes which are present in each module.
    /* m = modules definition
     * dp = true if module definition is created for the default profile
     */
    moduleDefinitions = m: dp:
      let
        /* check for reserved attributes; pass through return on success
         * n = attribute to be tested 
         * r = value that is returned on success
         */
        reservedModuleAttrs = attrNames (moduleDefaults false);
        #reservedModuleAttrs = [ "enable" "leader" "vimrc" ];
        assertReserved = n: r: assert !(elem n reservedModuleAttrs); r;
        # attribute set to add to the module stub
        stubExtension =
          let
            # in the default profile module options are strings
            defaultType = {type = types.string;};
            # in all other profiles module options default to null;
            #   null means that the value from the default profile is used 
            profileType = {type = types.nullOr types.string; default = null;};
          in
            if dp then defaultType else profileType;
      in
        mapAttrs (mod_name: stub: mkOption ((assertReserved mod_name stub) // stubExtension)) m.options;


    # create the combined config for a module
    # m = module declaration, that is set of option stubs
    # dp = true if module options are composed for the default profile
    composeOptions = m: dp: (moduleDefinitions m dp) // (moduleDefaults dp);



    # option flags that are added into each profile
    # dp = true for default profile
    profileDefaults = dp:
     let
       typesPrefix = if dp then id else types.nullOr;
       extension = if dp then { profiles = mkOption {
                                  type = types.attrsOf (types.submodule {options = makeProfile false;});
                                  default = {}; # TODO: is this the best place to add default profiles?
                                  description = "Vim profile configurations.";
                                }; }
                         else { parent = mkOption {
                                  type = types.nullOr types.string;
                                  default = null;
                                  description = "Parent profile to base configuration on; null for default profile.";
                                }; };
     in
       { plugins = mkOption {
           type = typesPrefix (types.listOf types.string);
           default = if dp then [] else null;
           description = "Vim plugins to include.";
         };
         paths = mkOption {
           type = typesPrefix (types.listOf types.package);
           default = if dp then [] else null;
           description = "Pathes to make accessible for vim.";
         };
         leader = mkOption {
           type = typesPrefix types.string;
           default = if dp then "\\\\\\\\" else null;
           description = "Default leader for that profile.";
         };
         vimrc = mkOption {
           type = typesPrefix types.string;
           default = if dp then "" else null;
           description = "Configuration to add into vimrc.";
         };
         exec = mkOption {
           type = typesPrefix types.attrs;
           default = if dp then {package=pkgs.vimPlain; bin="bin/vim";} else null;
           description = "Vim derivation to base profile on";
           options = {
             package = mkOption {
               type = types.package;
               default = pkgs.vimPlain;
               description = "Vim package";
             };
             bin = mkOption {
               type = types.string;
               default = "bin/vim";
               description = "Vim binary";
             };
           };
         };
         name = mkOption {
           type = typesPrefix types.string;
           default = if dp then "vim" else null;
           description = ''Name of the executable that calls vim with the profile.
                           In a profile other than the default profile, if null, then
                           the name derives automatically.'';
         };
         enable = mkOption {
           type = types.bool;
           default = false;
           description = "Enable the creation of the vim profile.";
         };
       } // extension;





    # create options of a profile
    makeProfile = dp: 
     let
         # check for reserved module names; these attribute names have special purposes
         assertModNames = 
           let
             reservedModuleNames = attrNames ((profileDefaults true) // (profileDefaults false));
             #reservedModuleNames = [ "plugins" "enable" "paths" "vimrc" "profiles" "leader" "exec" "name" "parent" ];
           in
             mods: assert !(any id ( map (mod_name: elem mod_name reservedModuleNames) (attrNames mods))); mods;
     in
       # turn the stubs of all modules into mkOptions, and add the profile specific mkOptions
       mapAttrs (_: m: composeOptions m dp) (assertModNames modules) // profileDefaults dp;

  };





  #
  # configuration
  #
  configHelpers = rec {

    # merge configs, where p_cfg is overwriting d_cfg 
    # d_cfg = default config
    # p_cfg = profile config
    mergeConfig = d_cfg: p_cfg:
      let
        profileChain =
          let
            chain = list:
              let
                head = elemAt list 0;
              in
                if isNull head.parent then list else chain ((singleton (getAttr head.parent d_cfg.profiles)) ++ list);
          in
            chain [p_cfg];
        # filter out options in profiles that should fall back to the default profile,
        # that leaves only the options which are overwriting the default profile
        filterOverwrites = cfg:
          let
            filteredModules =
              let 
                moduleOverwrites = mod_name: mod_cfg: {${mod_name} = (filterAttrs (n: v: !(isNull v)) mod_cfg);};
              in fold (a: b: a // b) {} (map (mod_name: moduleOverwrites mod_name (getAttr mod_name cfg)) (attrNames modules));
          in filterAttrs (n: v: n=="name" || n=="enable" || n=="parent" || !(isNull v)) (cfg // filteredModules);
      in
        # pt_cfg: parent config
        # o_cfg: overwrite config
        foldl (pt_cfg: o_cfg: recursiveUpdate pt_cfg (filterOverwrites o_cfg)) d_cfg profileChain;


    # evaluate the plugin configuration and extract the vimrc content, the plugins and the paths
    evaluateConfig = cfg:
      let
        # get modules which are enabled
        enabledModules = filterAttrs (n: _: (getAttr n cfg).enable) modules;

        # helper function
        uniqList' = list: uniqList {inputList=list;};
        wrapString = s: if elem s ["" "\n"] then [] else [s];

        # update the options of the module (m: v:) with the values from the configuration cfg
        moduleCfgs = m: v:
          let
            # configuration that corresponds to the module m
            m_cfg = getAttr m cfg;
            # option delarations of the module m
            m_options = v.options;
          in
            # transform an attribute of "" to null
            mapAttrs (a: _: let v=getAttr a m_cfg; in if v=="" then null else v) m_options;

        setLeaderCmd = leader: ["let mapleader=\"${leader}\""];

        leader = m: v: 
          let
            # configuration that corresponds to the module m
            m_cfg = getAttr m cfg;
          in
            setLeaderCmd (if isNull m_cfg.leader then cfg.leader else m_cfg.leader);

        commentLine = name: ["\n\">>> nix configuration module '${name}'"];
      in
        {
          # vimrc content of the profile
          # INFO: the content of profile.vimrc goes first!
          #       In contrast, the content of profile.module.vimrc goes after the generated content of each module.
          vimrc =
            let
              # INFO: wrap text sniplets into lists so that no unnecessary \n are added
              sniplets = m: v: flatten ((commentLine m) ++ (leader m v) ++ (wrapString (v.vimrc (moduleCfgs m v))) ++ (wrapString (getAttr m cfg).vimrc));
            in concatStringsSep "\n" ((setLeaderCmd cfg.leader) ++ (wrapString cfg.vimrc) ++ (flatten (mapAttrsFlatten sniplets enabledModules)));
          # get a list of all plugins that are enabled for the profile
          plugins = uniqList' (cfg.plugins ++ (flatten (mapAttrsFlatten (_:v: v.plugins) enabledModules)));
          # get a list of all paths that have to be included in the profile
          paths = uniqList' (cfg.paths ++ (flatten (mapAttrsFlatten (_:v: v.paths) enabledModules)));
        };
           

    # write content into a file in the nix store
    createVimDir = vimExecPackage: profile_name: vimrcContent: plugins:
      let
        pluginPackages = map (pluginName: getAttr pluginName pkgs.vimPlugins) plugins;
        rtps = 
          let
            toPluginPaths = pluginDeriv: "${pluginDeriv}/share/vim-plugins/${pluginDeriv.path}/";
          in
            concatStringsSep " " (map toPluginPaths pluginPackages);
      in
        pkgs.stdenv.mkDerivation rec {
          name = if isNull profile_name then "vimrc" else "vimrc-${profile_name}";
          buildInputs = pluginPackages;
          phases = ["installPhase"];
          installPhase = ''
            mkdir $out
            ln -s ${vimExecPackage}/share/vim/* $out/.
            rm -f $out/vimrc
            echo "set nocompatible" > $out/vimrc
            echo "" >> $out/vimrc
            for f in ${rtps}; do echo "set rtp^=$f" >> $out/vimrc; done
            for f in ${rtps}; do if [ -d $f/after ]; then echo "set rtp+=$f/after" >> $out/vimrc; fi; done
            echo "" >> $out/vimrc
            cat >> $out/vimrc <<EOF_NIXOS_VIMRC_CONFIGURATION
            ${vimrcContent}
            EOF_NIXOS_VIMRC_CONFIGURATION
          '';
          preferLocalBuild = true;
        };


    # make a derivation which links the content of all packages' bin folders into the derivation
    linkPackages = profile_name: packages:
      let
        packageLinkCommand = package: "ln -s ${package}/bin/* $out/.";
      in
        pkgs.stdenv.mkDerivation rec {
          name = if isNull profile_name then "vim-paths" else "vim-${profile_name}-paths";
          buildInputs = packages;
          phases = ["installPhase"];
          installPhase = "mkdir $out\n" + (concatStringsSep "\n" (map packageLinkCommand packages));
          preferLocalBuild = true;
        };


    # compile wrapper settings
    defineWrapper = profile_name: cfg:
      let
        # process configuration
        evaluation = evaluateConfig cfg;
        # gather the content of the vimrc file and create the file in a folder in the nix store
        vimDir = if (evaluation.vimrc=="") && (evaluation.plugins==[]) then null
                 else createVimDir cfg.exec.package profile_name evaluation.vimrc evaluation.plugins;
        # link the content of all packages/bin directories into a directory in the nix store
        pathsDir = if evaluation.paths==[] then null else linkPackages profile_name evaluation.paths;
        # define the name that the profiled vim is called with
        nameExecutable = if !(isNull cfg.name) then cfg.name else profile_name;
        # return command to wrap vim, or when an optimization is possible, just a command to link to vim
        buildCommand = if (isNull vimDir) && (isNull pathsDir)
          #TODO: return buildInputs so that they are not deleted accidentally
          then "ln -s ${cfg.exec.package}/${cfg.exec.bin} bin/${nameExecutable}"
          else # compose the command which creates the wrapper around vim
               "makeWrapper \"${cfg.exec.package}/${cfg.exec.bin}\" \"bin/${nameExecutable}\""
               + (if isNull vimDir then "" else " --set VIM \"${vimDir}\"")
               + (if isNull pathsDir then " --set PATH \"\"" else " --set PATH \"${pathsDir}\"");
                  #TODO: should the PATH be replaced completely, so that vim only sees a pre-defined environment?
        buildInputs = (if (isNull vimDir) then [] else [vimDir]) ++ (if (isNull pathsDir) then [] else [pathsDir]);
      in
        {buildCommand=buildCommand; buildInputs=(uniqList {inputList=buildInputs;});};



  };
in
{
  ###### interface
  options = {
       programs.vim = optionsHelpers.makeProfile true;
     };


  ###### configuration
  config =
   let
     # the default config
     defaultCfg = (filterAttrs (n: v: n != "profile") config.programs.vim);
     enabledProfiles = filterAttrs (n: v: v.enable) config.programs.vim.profiles;

     vimProfilesConfig = mapAttrs (p_name: p_cfg: configHelpers.defineWrapper p_name (configHelpers.mergeConfig defaultCfg p_cfg)) enabledProfiles;
     vimDefaultConfig = if defaultCfg.enable then (configHelpers.defineWrapper null defaultCfg) else null;

     # reduce the priority of the default configuration;
     vimProfileOptionDefaults =
       let
         default = mapAttrs (n: value: mkDefault value) defaultConfig;
         profiles = (mapAttrsRecursive (path: value: if ((length path) <= 2) then mkDefault value else value) defaultConfig.profiles);
       in
         if (hasAttr "profiles" defaultConfig) then
           default // { profiles = (mkDefault profiles); }
         else default;
   in 
    {nixpkgs.config.vim.profile = vimDefaultConfig; nixpkgs.config.vimProfiles = vimProfilesConfig; programs.vim = vimProfileOptionDefaults;};
}

