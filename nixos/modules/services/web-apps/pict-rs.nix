{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.pict-rs;
  inherit (lib) maintainers mkOption types;

  is03 = lib.versionOlder cfg.package.version "0.4.0";

in
{
  meta.maintainers = with maintainers; [ happysalada ];
  meta.doc = ./pict-rs.md;

  options.services.pict-rs = {
    enable = lib.mkEnableOption "pict-rs server";

    package = lib.mkPackageOption pkgs "pict-rs" { };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/pict-rs";
      description = ''
        The directory where to store the uploaded images & database.
      '';
    };

    repoPath = mkOption {
      type = types.nullOr (types.path);
      default = null;
      description = ''
        The directory where to store the database.
        This option takes precedence over dataDir.
      '';
    };

    storePath = mkOption {
      type = types.nullOr (types.path);
      default = null;
      description = ''
        The directory where to store the uploaded images.
        This option takes precedence over dataDir.
      '';
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        The IPv4 address to deploy the service to.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = ''
        The port which to bind the service to.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.pict-rs.package = lib.mkDefault (
      # An incompatible db change happened in the transition from 0.3 to 0.4.
      if lib.versionAtLeast config.system.stateVersion "23.11" then pkgs.pict-rs else pkgs.pict-rs_0_3
    );

    # Account for config differences between 0.3 and 0.4
    assertions = [
      {
        assertion = !is03 || (cfg.repoPath == null && cfg.storePath == null);
        message = ''
          Using `services.pict-rs.repoPath` or `services.pict-rs.storePath` with pict-rs 0.3 or older has no effect.
        '';
      }
    ];

    systemd.services.pict-rs = {
      # Pict-rs split it's database and image storage paths in 0.4.0.
      environment =
        if is03 then
          {
            PICTRS__PATH = cfg.dataDir;
            PICTRS__ADDR = "${cfg.address}:${toString cfg.port}";
          }
        else
          {
            PICTRS__REPO__PATH = if cfg.repoPath != null then cfg.repoPath else "${cfg.dataDir}/sled-repo";
            PICTRS__STORE__PATH = if cfg.storePath != null then cfg.storePath else "${cfg.dataDir}/files";
            PICTRS__SERVER__ADDR = "${cfg.address}:${toString cfg.port}";
          };
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "pict-rs";
        ExecStart =
          if is03 then
            "${lib.getBin cfg.package}/bin/pict-rs"
          else
            "${lib.getBin cfg.package}/bin/pict-rs run";
      };
    };
  };

}
