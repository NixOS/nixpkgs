{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  cfg = config.services.goatcounter;
  stateDir = "goatcounter";
in

{
  options = {
    services.goatcounter = {
      enable = lib.mkEnableOption "goatcounter";

      package = lib.mkPackageOption pkgs "goatcounter" { };

      address = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Web interface address.";
      };

      port = lib.mkOption {
        type = types.port;
        default = 8081;
        description = "Web interface port.";
      };

      proxy = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether Goatcounter service is running behind a reverse proxy. Will listen for HTTPS if `false`.
          Refer to [documentation](https://github.com/arp242/goatcounter?tab=readme-ov-file#running) for more details.
        '';
      };

      extraArgs = lib.mkOption {
        type = with types; listOf str;
        default = [ ];
        description = ''
          List of extra arguments to be passed to goatcounter cli.
          See {command}`goatcounter help serve` for more information.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.goatcounter = {
      description = "Easy web analytics. No tracking of personal data.";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "serve"
            "-listen"
            "${cfg.address}:${toString cfg.port}"
          ]
          ++ lib.optionals cfg.proxy [
            "-tls"
            "proxy"
          ]
          ++ cfg.extraArgs
        );
        DynamicUser = true;
        StateDirectory = stateDir;
        WorkingDirectory = "%S/${stateDir}";
        Restart = "always";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ bhankas ];
}
