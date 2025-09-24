{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.sonic-server;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "sonic-server-config.toml" cfg.settings;

in
{
  meta.maintainers = [ lib.maintainers.anthonyroussel ];

  options = {
    services.sonic-server = {
      enable = lib.mkEnableOption "Sonic Search Index";

      package = lib.mkPackageOption pkgs "sonic-server" { };

      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = settingsFormat.type; };
        default = {
          store.kv.path = "/var/lib/sonic/kv";
          store.fst.path = "/var/lib/sonic/fst";
        };
        example = {
          server.log_level = "debug";
          channel.inet = "[::1]:1491";
        };
        description = ''
          Sonic Server configuration options.

          Refer to
          <https://github.com/valeriansaliou/sonic/blob/master/CONFIGURATION.md>
          for a full list of available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.sonic-server.settings = lib.mapAttrs (name: lib.mkDefault) {
      server = { };
      channel.search = { };
      store = {
        kv = {
          path = "/var/lib/sonic/kv";
          database = { };
          pool = { };
        };
        fst = {
          path = "/var/lib/sonic/fst";
          graph = { };
          pool = { };
        };
      };
    };

    systemd.services.sonic-server = {
      description = "Sonic Search Index";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";

        ExecStart = "${lib.getExe cfg.package} -c ${configFile}";
        DynamicUser = true;
        Group = "sonic";
        LimitNOFILE = "infinity";
        Restart = "on-failure";
        StateDirectory = "sonic";
        StateDirectoryMode = "750";
        User = "sonic";
      };
    };
  };
}
