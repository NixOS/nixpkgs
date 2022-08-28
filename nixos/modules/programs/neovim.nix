{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.neovim;

  runtime' = filter (f: f.enable) (attrValues cfg.runtime);

  runtime = pkgs.linkFarm "neovim-runtime" (map (x: { name = x.target; path = x.source; }) runtime');

in {
  options.programs.neovim = {
    enable = mkEnableOption (lib.mdDoc "Neovim");

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        When enabled, installs neovim and configures neovim to be the default editor
        using the EDITOR environment variable.
      '';
    };

    viAlias = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Symlink {command}`vi` to {command}`nvim` binary.
      '';
    };

    vimAlias = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Symlink {command}`vim` to {command}`nvim` binary.
      '';
    };

    withRuby = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Enable Ruby provider.";
    };

    withPython3 = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Enable Python 3 provider.";
    };

    withNodeJs = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Enable Node provider.";
    };

    configure = mkOption {
      type = types.attrs;
      default = {};
      example = literalExpression ''
        {
          customRC = '''
            " here your custom configuration goes!
          ''';
          packages.myVimPackage = with pkgs.vimPlugins; {
            # loaded on launch
            start = [ fugitive ];
            # manually loadable by calling `:packadd $plugin-name`
            opt = [ ];
          };
        }
      '';
      description = lib.mdDoc ''
        Generate your init file from your list of plugins and custom commands.
        Neovim will then be wrapped to load {command}`nvim -u /nix/store/«hash»-vimrc`
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      defaultText = literalExpression "pkgs.neovim-unwrapped";
      description = lib.mdDoc "The package to use for the neovim binary.";
    };

    finalPackage = mkOption {
      type = types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized neovim package.";
    };

    runtime = mkOption {
      default = {};
      example = literalExpression ''
        { "ftplugin/c.vim".text = "setlocal omnifunc=v:lua.vim.lsp.omnifunc"; }
      '';
      description = lib.mdDoc ''
        Set of files that have to be linked in {file}`runtime`.
      '';

      type = with types; attrsOf (submodule (
        { name, config, ... }:
        { options = {

            enable = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Whether this /etc file should be generated.  This
                option allows specific /etc files to be disabled.
              '';
            };

            target = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Name of symlink.  Defaults to the attribute
                name.
              '';
            };

            text = mkOption {
              default = null;
              type = types.nullOr types.lines;
              description = lib.mdDoc "Text of the file.";
            };

            source = mkOption {
              type = types.path;
              description = lib.mdDoc "Path of the source file.";
            };

          };

          config = {
            target = mkDefault name;
            source = mkIf (config.text != null) (
              let name' = "neovim-runtime" + baseNameOf name;
              in mkDefault (pkgs.writeText name' config.text));
          };

        }));

    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.finalPackage
    ];
    environment.variables.EDITOR = mkIf cfg.defaultEditor (mkOverride 900 "nvim");

    programs.neovim.finalPackage = pkgs.wrapNeovim cfg.package {
      inherit (cfg) viAlias vimAlias withPython3 withNodeJs withRuby;
      configure = cfg.configure // {

        customRC = (cfg.configure.customRC or "") + ''
          set runtimepath^=${runtime}/etc
        '';
      };
    };
  };
}
