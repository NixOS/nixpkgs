# Global configuration for spacefm.

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.spacefm;

in
{
  ###### interface

  options = {

    programs.spacefm = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to install SpaceFM and create {file}`/etc/spacefm/spacefm.conf`.
        '';
      };

      settings = mkOption {
        type = types.attrs;
        default = {
          tmp_dir = "/tmp";
          terminal_su = "${pkgs.sudo}/bin/sudo";
        };
        defaultText = literalExpression ''
          {
            tmp_dir = "/tmp";
            terminal_su = "''${pkgs.sudo}/bin/sudo";
          }
        '';
        description = lib.mdDoc ''
          The system-wide spacefm configuration.
          Parameters to be written to {file}`/etc/spacefm/spacefm.conf`.
          Refer to the [relevant entry](https://ignorantguru.github.io/spacefm/spacefm-manual-en.html#programfiles-etc) in the SpaceFM manual.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.spaceFM ];

    environment.etc."spacefm/spacefm.conf".text =
      concatStrings (mapAttrsToList (n: v: "${n}=${toString v}\n") cfg.settings);
  };
}
