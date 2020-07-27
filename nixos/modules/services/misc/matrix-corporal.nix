{ lib, pkgs, config, ... }:
let
  cfg = config.services.matrix-corporal;
  matrix-corporal-config = pkgs.writeTextFile {
    name = "matrix-corporal-config.json";
    text = lib.generators.toJSON {} cfg.settings;
  };
in
{
  options.services.matrix-corporal = {
    enable = lib.mkEnableOption "matrix-corporal";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.matrix-corporal;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        Matrix = {
          HomeserverApiEndpoint = "localhost:8008";
          TimeoutMilliseconds = 45000;
        };
        Reconciliation = {
          UserId = "@matrix-corporal:" + cfg.settings.matrix.HomeserverDomainName;
          RetryIntervalMilliseconds = 30000;
        };
        HttpGateway = {
          ListenAddress = "127.0.0.1:41080";
        };
        HttpApi = {
          Enabled = true;
          ListenAddress = "127.0.0.1:41081";
        };
        PolicyProvider = {
          Type = "static_file";
          Path = "/etc/matrix-corporal/policy.json";
        };
        Misc = {
          Debug = true;
        };
      };
      description = ''
        Configuration for matrix-corporal, see <link xlink:href="https://github.com/devture/matrix-corporal/blob/master/docs/configuration.md"/>
        for supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.matrix-corporal = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/matrix-corporal -c ${matrix-corporal-config}}";
      };
    };
  };
}
