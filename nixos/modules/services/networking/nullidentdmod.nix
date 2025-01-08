{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nullidentdmod;

in
{
  options.services.nullidentdmod = with lib.types; {
    enable = lib.mkEnableOption "the nullidentdmod identd daemon";

    userid = lib.mkOption {
      type = nullOr str;
      description = "User ID to return. Set to null to return a random string each time.";
      default = null;
      example = "alice";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.sockets.nullidentdmod = {
      description = "Socket for identd (NullidentdMod)";
      listenStreams = [ "113" ];
      socketConfig.Accept = true;
      wantedBy = [ "sockets.target" ];
    };

    systemd.services."nullidentdmod@" = {
      description = "NullidentdMod service";
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.nullidentdmod}/bin/nullidentdmod${
          lib.optionalString (cfg.userid != null) " ${cfg.userid}"
        }";
        StandardInput = "socket";
        StandardOutput = "socket";
      };
    };
  };
}
