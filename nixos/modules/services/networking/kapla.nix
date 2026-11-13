{
  pkgs,
  lib,
  config,
  utils,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkOption
    mkIf
    optionalAttrs
    optionals
    types
    ;
  cfg = config.services.kapla;
in
{
  meta = {
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    teams = [ lib.teams.ngi ];
  };

  options = {
    services.kapla = {
      enable = mkEnableOption "Kapla storage and transport service";

      package = mkOption {
        description = "Package to use for Kapla.";
        default = pkgs.ocamlPackages.kapla;
        defaultText = "pkgs.ocamlPackages.kapla";
        type = types.package;
      };

      openFirewall = mkEnableOption "Open the UDP ports for CoAP peers to connect";

      user = mkOption {
        description = "User the kapla binary should execute under.";
        type = types.str;
        default = "kapla";
        example = "kapla";
      };

      group = mkOption {
        description = "Group required to access the kapla socket";
        type = types.str;
        default = "kapla";
        example = "kapla";
      };

      erisSocket = {
        path = mkOption {
          description = "The socket to listen for eris connections on.";
          type = types.str;
          default = "/var/lib/kapla/eris.sock";
          example = "/var/lib/kapla/eris.sock";
        };
        setSessionVariable = (mkEnableOption "Expose the eris socket in ERIS_UNIX_SOCKET") // {
          default = true;
        };
      };

      dataDirectory = mkOption {
        description = "Directory where the ERIS blocks are stored.";
        type = types.str;
        default = "/var/lib/kapla";
        example = "/var/lib/kapla";
      };

      stateDirectory = mkOption {
        description = "Directory for kapla's socket and lock files.";
        type = types.str;
        default = "/var/lib/kapla";
        example = "/var/lib/kapla";
      };

      extraArgs = mkOption {
        description = "Extra arguments to pass to `kapla serve`.";
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    users.users = optionalAttrs (cfg.user == "kapla") {
      kapla = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == "kapla") {
      kapla = { };
    };

    networking.firewall.allowedUDPPorts = optionals cfg.openFirewall [
      5683
    ];

    environment = {
      systemPackages = [ cfg.package ];
      sessionVariables = mkIf cfg.erisSocket.setSessionVariable {
        ERIS_UNIX_SOCKET = cfg.erisSocket.path;
      };
    };

    systemd.services.kapla = {
      description = "Kapla";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = utils.escapeSystemdExecArgs (
          [
            "${getExe cfg.package}"
            "serve"
            "--socket=${cfg.erisSocket.path}"
            "--data=${cfg.dataDirectory}"
            "--state=${cfg.stateDirectory}"
          ]
          ++ cfg.extraArgs
        );
        Type = "simple";
        Restart = "on-failure";
        StateDirectory = "kapla";
      };
    };
  };
}
