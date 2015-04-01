{ config, lib, pkgs, utils, ... }:

with lib;

{

  ###### interface

  options = with types; {

    services.freefall = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to protect HP/Dell laptop hard drives (not SSDs) in free fall.
        '';
        type = bool;
      };

      devices = mkOption {
        default = [ "/dev/sda" ];
        description = ''
          Device paths to all internal spinning hard drives.
        '';
        type = listOf string;
      };

    };

  };

  ###### implementation

  config = let

    cfg = config.services.freefall;

    mkService = dev:
      assert dev != "";
      let dev' = utils.escapeSystemdPath dev; in
      nameValuePair "freefall-${dev'}"
        { description = "Free-fall protection for ${dev}";
        after = [ "${dev'}.device" ];
        wantedBy = [ "${dev'}.device" ];
        path = [ pkgs.freefall ];
        serviceConfig = {
          ExecStart = "${pkgs.freefall}/bin/freefall ${dev}";
          Restart = "on-failure";
          Type = "forking";
        };
      };

  in mkIf cfg.enable {

    environment.systemPackages = [ pkgs.freefall ];

    systemd.services = listToAttrs (map mkService cfg.devices);

  };

}
