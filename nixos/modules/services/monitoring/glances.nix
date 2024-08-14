{ pkgs, config, lib, ... }:
let
  cfg = config.services.glances;

  inherit (lib)
    escapeShellArgs
    maintainers
    mkEnableOption
    mkOption
    mkIf
    mkPackageOption
    ;

  inherit (lib.types)
    bool
    listOf
    port
    str
    ;
in
{
  options.services.glances = {
    enable = mkEnableOption "Glances";

    package = mkPackageOption pkgs "glances" { };

    port = mkOption {
      description = "Port the server will isten on.";
      type = port;
      default = 61208;
    };

    openFirewall = mkOption {
      description = "Open port in the firewall for glances.";
      type = bool;
      default = false;
    };

    commandlineArgs = mkOption {
      type = listOf str;
      default = [ "--webserver" ];
      example = [ "--webserver" "--disable-webui" ];
      description = ''
        Set commandline arguments to pass to glances. See
        https://glances.readthedocs.io/en/latest/cmds.html.
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services."glances" = {
      description = "Glances";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "root";
        ExecStart = "${cfg.package}/bin/glances --port ${toString cfg.port} ${escapeShellArgs cfg.commandlineArgs}";
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with maintainers; [ claha ];
}
