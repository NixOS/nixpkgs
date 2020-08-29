{ config, pkgs, lib, ... }:

let
  cfg = config.services.improut;
  defaultGroup = "improut";

in {
  options.services.improut = {
    enable = lib.mkEnableOption "improut image hosting";

    storageDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/improut";
      example = "/var/lib/improut";
      description = ''
        Directory to store uploaded images.
      '';
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      example = "localhost";
      description = ''
        Hostname to listen on.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8985;
      example = 8985;
      description = ''
        Port to listen on.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "improut";
      example = "improut";
      description = ''
        Group owning the uploaded files.
      '';
    };

    maxSize = lib.mkOption {
      type = lib.types.int;
      default = 10485760;  # 10 MiB
      example = 10485760;
      description = ''
        Maximum upload body size to accept, in bytes. Actual maximum file size will be a few bytes smaller.
      '';
    };

    maxLifetime = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 30;
      description = ''
        Maximum lifetime in days this improut server supports. <literal>0</literal> for unlimited.
      '';
    };

    defaultLifetime = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 7;
      description = ''
        Default lifetime in days. Users can set a different value as long as it's below <literal>maxLifetime</literal>.
        <literal>0</literal> for unlimited default lifetime.
      '';
    };

    expireCheckInterval = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 24;
      description = ''
        Interval in hours to scan for and delete expired images.
      '';
    };

    xAccel = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/storage";
      description = ''
        If non-null, enables X-Accel-Redirect mechanism with this prefix instead of serving images from improut.
        This will set the header <literal>X-Accel-Redirect: {xAccel}/{image-name}</literal>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups."${cfg.group}" = {};
    systemd.tmpfiles.rules = [ "d '${cfg.storageDir}' 0770 root ${cfg.group} -" ];
    systemd.services.improut = {
      description = "improut image hosting server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        SupplementaryGroups = cfg.group;
        Restart = "on-failure";
        ExecStart = ''
          ${pkgs.improut}/bin/improut \
            -listen ${cfg.listenAddress}:${toString cfg.port} \
            -root ${cfg.storageDir} \
            -max-size ${toString cfg.maxSize} \
            ${lib.optionalString (cfg.maxLifetime != null) "-max-lifetime ${toString cfg.maxLifetime}"} \
            ${lib.optionalString (cfg.defaultLifetime != null) "-default-lifetime ${toString cfg.defaultLifetime}"} \
            ${lib.optionalString (cfg.expireCheckInterval != null) "-expire-interval ${toString cfg.expireCheckInterval}"} \
            ${lib.optionalString (cfg.xAccel != null) "-xaccel ${cfg.xAccel}"}
        '';
      };
    };
  };
}
