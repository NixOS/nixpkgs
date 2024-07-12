# Global configuration for spacefm.

{ config, lib, pkgs, ... }:

let cfg = config.programs.spacefm;

in
{
  ###### interface

  options = {

    programs.spacefm = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install SpaceFM and create {file}`/etc/spacefm/spacefm.conf`.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {
          tmp_dir = "/tmp";
          terminal_su = "${pkgs.sudo}/bin/sudo";
        };
        defaultText = lib.literalExpression ''
          {
            tmp_dir = "/tmp";
            terminal_su = "''${pkgs.sudo}/bin/sudo";
          }
        '';
        description = ''
          The system-wide spacefm configuration.
          Parameters to be written to {file}`/etc/spacefm/spacefm.conf`.
          Refer to the [relevant entry](https://ignorantguru.github.io/spacefm/spacefm-manual-en.html#programfiles-etc) in the SpaceFM manual.
        '';
      };

    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.spaceFM ];

    environment.etc."spacefm/spacefm.conf".text =
      lib.concatStrings (lib.mapAttrsToList (n: v: "${n}=${builtins.toString v}\n") cfg.settings);
  };
}
