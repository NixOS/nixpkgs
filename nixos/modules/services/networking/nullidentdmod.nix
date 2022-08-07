{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.nullidentdmod;

in {
  options.services.nullidentdmod = with types; {
    enable = mkEnableOption "the nullidentdmod identd daemon";

    userid = mkOption {
      type = nullOr str;
      description = lib.mdDoc "User ID to return. Set to null to return a random string each time.";
      default = null;
      example = "alice";
    };
  };

  config = mkIf cfg.enable {
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
        ExecStart = "${pkgs.nullidentdmod}/bin/nullidentdmod${optionalString (cfg.userid != null) " ${cfg.userid}"}";
        StandardInput = "socket";
        StandardOutput = "socket";
      };
    };
  };
}
