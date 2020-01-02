{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.documentation.apropos;

in

{

  options.documentation.apropos = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to crete an apropos cache for the generated system path.
        '';
      };
  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [ "d /var/cache/man 0755 root root -" ];

    system.activationScripts.apropos = ''
      ${pkgs.mandb}/bin/mandb
    '';

  };

}
