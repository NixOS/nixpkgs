{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.neovim;

  runtime' = filter (f: f.enable) (attrValues cfg.runtime);

  # taken from the etc module
  runtime = pkgs.stdenvNoCC.mkDerivation {
    name = "runtime";

    builder = ../system/etc/make-etc.sh;

    preferLocalBuild = true;
    allowSubstitutes = false;

    sources = map (x: x.source) runtime';
    targets = map (x: x.target) runtime';
  };

in {
  options.programs.neovim = {
    enable = mkEnableOption "Neovim";

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, installs neovim and configures neovim to be the default editor
        using the EDITOR environment variable.
      '';
    };

    viAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Symlink <command>vi</command> to <command>nvim</command> binary.
      '';
    };

    vimAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Symlink <command>vim</command> to <command>nvim</command> binary.
      '';
    };

    withRuby = mkOption {
      type = types.bool;
      default = true;
      description = "Enable ruby provider.";
    };

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
        Generate your init file from your list of plugins and custom commands.
        Neovim will then be wrapped to load <command>nvim -u /nix/store/<replaceable>hash</replaceable>-vimrc</command>
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      defaultText = literalExample "pkgs.neovim-unwrapped";
      description = "The package to use for the neovim binary.";
    };

    finalPackage = mkOption {
      type = types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized neovim package.";
    };

    runtime = mkOption {
      default = {};
      example = literalExample ''
        runtime."ftplugin/c.vim".text = "setlocal omnifunc=v:lua.vim.lsp.omnifunc";
      '';
      description = ''
        Set of files that have to be linked in <filename>runtime</filename>.
      '';

      type = with types; attrsOf (submodule (
        { name, config, ... }:
        { options = {

            enable = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether this /etc file should be generated.  This
                option allows specific /etc files to be disabled.
              '';
            };

            target = mkOption {
              type = types.str;
              description = ''
                Name of symlink.  Defaults to the attribute
                name.
              '';
            };

            text = mkOption {
              default = null;
              type = types.nullOr types.lines;
              description = "Text of the file.";
            };

            source = mkOption {
              type = types.path;
              description = "Path of the source file.";
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
    environment.variables = { EDITOR = mkOverride 900 "nvim"; };

    programs.neovim.finalPackage = pkgs.wrapNeovim cfg.package {
      inherit (cfg) viAlias vimAlias;
      configure = cfg.configure // {

        customRC = (cfg.configure.customRC or "") + ''
          set runtimepath^=${runtime}/etc
        '';
      };
    };
  };
}
