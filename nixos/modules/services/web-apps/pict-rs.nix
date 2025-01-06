{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.pict-rs;
  inherit (lib) maintainers mkOption types;
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
      if lib.versionAtLeast config.system.stateVersion "23.11" then
        pkgs.pict-rs
      else
        throw ''
          pict-rs made changes to the database schema between 0.3 and 0.4. It
          will apply these automatically on the first run of 0.4, but the old
          version will no longer work after that.

          Your configuration is currently using the old default of pict-rs
          0.3. Unfortunately, 0.3 no longer builds due to the Rust 1.80 update,
          and has been removed. pict-rs has already been updated to 0.5 in
          Nixpkgs, which has another schema change but removes the migration
          logic for 0.3.

          You will need to migrate to 0.4 first, and then to 0.5. As 0.4 is
          no longer present in Nixpkgs, the recommended migration path is:

          * Import a separate Nixpkgs old enough to contain 0.4, temporarily
            set `services.pict-rs.package` to its pict-rs, set the
            `PICTRS__OLD_DB__PATH` environment variable for the migration, and
            activate your configuration to start it. The following configuration
            snippet should work:

                services.pict-rs.package =
                  (import (builtins.fetchTarball {
                    url = "https://github.com/NixOS/nixpkgs/archive/9b19f5e77dd906cb52dade0b7bd280339d2a1f3d.tar.gz";
                    sha256 = "sha256:0939vbhln9d33xkqw63nsk908k03fxihj85zaf70i3il9z42q8mc";
                  }) pkgs.config).pict-rs;

                systemd.services.pict-rs.environment.PICTRS__OLD_DB__PATH = config.services.pict-rs.dataDir;

          * After the migration to 0.4 completes, remove the package and
            environment variable overrides, set `services.pict-rs.package` to
            the current `pkgs.pict-rs` instead, and activate your configuration
            to begin the migration to 0.5.

          For more information, see:

          * <https://git.asonix.dog/asonix/pict-rs/src/tag/v0.4.8#0-3-to-0-4-migration-guide>
          * <https://git.asonix.dog/asonix/pict-rs/src/tag/v0.5.16#0-4-to-0-5-migration-guide>

          The NixOS module will handle the configuration changes for you,
          at least.
        ''
    );

    systemd.services.pict-rs = {
      environment = {
        PICTRS__REPO__PATH = if cfg.repoPath != null then cfg.repoPath else "${cfg.dataDir}/sled-repo";
        PICTRS__STORE__PATH = if cfg.storePath != null then cfg.storePath else "${cfg.dataDir}/files";
        PICTRS__SERVER__ADDRESS = "${cfg.address}:${toString cfg.port}";
      };
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "pict-rs";
        ExecStart = "${lib.getBin cfg.package}/bin/pict-rs run";
      };
    };
  };

}
