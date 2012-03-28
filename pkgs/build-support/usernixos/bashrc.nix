# Generator for .bashrc
{pkgs, config, ...}:

with pkgs.lib;

let
  bashrcFile = pkgs.writeScript "bashrc" config.bashrc.contents;
  cfg = config.bashrc;
in
{
  options = {
    environment.editor = mkOption {
      default = "${pkgs.vim}/bin/vim";
      type = types.string;
      description = ''
        Editor
      '';
    };

    bashrc = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable of .bashrc generation on activation
        '';
      };

      destination = mkOption {
        default = "~/.bashrc";
        type = types.string;
        description = ''
          The symlink that will point to the generated bashrc at activation time
        '';
      };

      contents = mkOption {
        default = "";
        type = types.string;
        merge = concatStringsSep "\n";
        description = ''
          Enable of .bashrc generation on activation
        '';
      };
    };
  };

  config.bashrc.contents = ''
    export EDITOR="${config.environment.editor}"
  '';

  config.activationContents = mkIf cfg.enable ''
    if [ -e "${cfg.destination}" ]; then
      echo Cannot set "${cfg.destination}", it exists
      exit 1
    fi
    ln -sf ${bashrcFile} "${cfg.destination}"
  '';
}
