{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.neovim;
  runtimeFiles = pkgs.generatedFiles {
    namePrefix = "nvim-runtime";
    relativeTo = "{file}`/etc/xdg/nvim`";
  };
in
{
  options.programs.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable Neovim.

        When enabled through this option, Neovim is wrapped to use a
        configuration managed by this module. The configuration file in the
        user's home directory at {file}`~/.config/nvim/init.vim` is no longer
        loaded by default.
      '';
    };

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        When enabled, installs neovim and configures neovim to be the default editor
        using the EDITOR environment variable.
      '';
    };

    viAlias = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Symlink {command}`vi` to {command}`nvim` binary.
      '';
    };

    vimAlias = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Symlink {command}`vim` to {command}`nvim` binary.
      '';
    };

    withRuby = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Ruby provider.";
    };

    withPython3 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Python 3 provider.";
    };

    withNodeJs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Node provider.";
    };

    configure = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = lib.literalExpression ''
        {
          customRC = '''
            " here your custom VimScript configuration goes!
          ''';
          customLuaRC = '''
            -- here your custom Lua configuration goes!
          ''';
          packages.myVimPackage = with pkgs.vimPlugins; {
            # loaded on launch
            start = [ fugitive ];
            # manually loadable by calling `:packadd $plugin-name`
            opt = [ ];
          };
        }
      '';
      description = ''
        Generate your init file from your list of plugins and custom commands.
        Neovim will then be wrapped to load {command}`nvim -u /nix/store/«hash»-vimrc`
      '';
    };

    package = lib.mkPackageOption pkgs "neovim-unwrapped" { };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized neovim package.";
    };

    runtime = lib.mkOption {
      default = { };
      example = lib.literalExpression ''
        { "ftplugin/c.vim".text = "setlocal omnifunc=v:lua.vim.lsp.omnifunc"; }
      '';
      description = ''
        Set of files that have to be linked in {file}`runtime`.
      '';

      type = lib.types.attrsOf runtimeFiles.type;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.finalPackage
    ];
    environment.sessionVariables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");
    # On most NixOS configurations /share is already included, so it includes
    # this directory as well. But  This makes sure that /share/nvim/site paths
    # from other packages will be used by neovim.
    environment.pathsToLink = [ "/share/nvim" ];

    environment.etc = lib.mapAttrs' (name: value: {
      name = "xdg/nvim/${name}";
      value = {
        inherit (value) enable source;
        target = "xdg/nvim/${value.target}";
      };
    }) cfg.runtime;

    programs.neovim.finalPackage = pkgs.wrapNeovim cfg.package {
      inherit (cfg)
        viAlias
        vimAlias
        withPython3
        withNodeJs
        withRuby
        configure
        ;
    };
  };
}
