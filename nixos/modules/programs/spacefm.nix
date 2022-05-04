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
        description = ''
          Whether to install SpaceFM and create <filename>/etc/spacefm/spacefm.conf</filename>.
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
        description = ''
          The system-wide spacefm configuration.
          Parameters to be written to <filename>/etc/spacefm/spacefm.conf</filename>.
          Refer to the <link xlink:href="https://ignorantguru.github.io/spacefm/spacefm-manual-en.html#programfiles-etc">relevant entry</link> in the SpaceFM manual.
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
