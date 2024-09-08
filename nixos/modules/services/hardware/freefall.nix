{ config, lib, pkgs, utils, ... }:
let

  cfg = config.services.freefall;

in {

  options.services.freefall = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to protect HP/Dell laptop hard drives (not SSDs) in free fall.
      '';
    };

    package = lib.mkPackageOption pkgs "freefall" { };

    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "/dev/sda" ];
      description = ''
        Device paths to all internal spinning hard drives.
      '';
    };

  };

  config = let

    mkService = dev:
      assert dev != "";
      let dev' = utils.escapeSystemdPath dev; in
      lib.nameValuePair "freefall-${dev'}" {
        description = "Free-fall protection for ${dev}";
        after = [ "${dev'}.device" ];
        wantedBy = [ "${dev'}.device" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/freefall ${dev}";
          Restart = "on-failure";
          Type = "forking";
        };
      };

  in lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services = builtins.listToAttrs (map mkService cfg.devices);

  };

}
