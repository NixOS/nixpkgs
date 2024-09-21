{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.turn-rs;
  format = pkgs.formats.toml { };
in
{
  options.services.turn-rs = {
    enable = lib.mkEnableOption "turn-rs server";
    package = lib.mkPackageOption pkgs "turn-rs" { };

    secretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/keys/turn-rs.env";
      description = ''
        Environment variables from this file will be interpolated into the
        final config file using envsubst with this syntax: `$ENVIRONMENT` or
        `''${VARIABLE}`.
        The file should contain lines formatted as `SECRET_VAR=SECRET_VALUE`.
        This is useful to avoid putting secrets into the nix store.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      description = "Turn-rs server config file";
      default = { };
      example = {
        turn = {
          realm = "localhost";
          interfaces = [
            {
              transport = "udp";
              bind = "127.0.0.1:3478";
              external = "127.0.0.1:3478";
            }
            {
              transport = "tcp";
              bind = "127.0.0.1:3478";
              external = "127.0.0.1:3478";
            }
          ];
        };

        auth.static_credentials = {
          user1 = "test";
          user2 = "test";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.turn-rs.settings = {
      api.bind = lib.mkDefault "127.0.0.1:3000";
      log.level = lib.mkDefault "info";
    };

    systemd.services.turn-rs = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      description = "Turn-rs Server Daemon";
      preStart =
        let
          configFile = format.generate "turn-rs-config.toml" cfg.settings;
        in
        ''
          ${lib.getExe pkgs.envsubst} -i "${configFile}" -o /run/turn-rs/config.toml
        '';
      serviceConfig = {
        RuntimeDirectory = "turn-rs";
        EnvironmentFile = lib.optional (cfg.secretFile != null) cfg.secretFile;
        ExecStart = "${lib.getExe cfg.package} --config=/run/turn-rs/config.toml";
        DynamicUser = true;
      };
    };
  };
}
