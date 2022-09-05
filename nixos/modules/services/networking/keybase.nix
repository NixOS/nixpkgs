{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keybase;

in {

  ###### interface

  options = {

    services.keybase = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to start the Keybase service.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    # Upstream: https://github.com/keybase/client/blob/master/packaging/linux/systemd/keybase.service
    systemd.user.services.keybase = {
      description = "Keybase service";
      unitConfig.ConditionUser = "!@system";
      environment.KEYBASE_SERVICE_TYPE = "systemd";
      serviceConfig = {
        Type = "notify";
        EnvironmentFile = [
          "-%E/keybase/keybase.autogen.env"
          "-%E/keybase/keybase.env"
        ];
        ExecStart = "${pkgs.keybase}/bin/keybase service";
        Restart = "on-failure";
        PrivateTmp = true;
      };
      wantedBy = [ "default.target" ];
    };

    environment.systemPackages = [ pkgs.keybase ];
  };
}
