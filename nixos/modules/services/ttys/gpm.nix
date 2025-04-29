{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.gpm;

in

{

  ###### interface

  options = {

    services.gpm = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GPM, the General Purpose Mouse daemon,
          which enables mouse support in virtual consoles.
        '';
      };

      protocol = mkOption {
        type = types.str;
        default = "ps/2";
        description = "Mouse protocol to use.";
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.gpm = {
      description = "Console Mouse Daemon";

      wantedBy = [ "multi-user.target" ];
      requires = [ "dev-input-mice.device" ];
      after = [ "dev-input-mice.device" ];

      serviceConfig.ExecStart = "@${pkgs.gpm}/sbin/gpm gpm -m /dev/input/mice -t ${cfg.protocol}";
      serviceConfig.Type = "forking";
      serviceConfig.PIDFile = "/run/gpm.pid";
    };

  };

}
