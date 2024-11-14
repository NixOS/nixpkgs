{ config, lib, pkgs, ... }:
let
  cfg = config.services.foldingathome;

  args =
    ["--team" "${toString cfg.team}"]
    ++ lib.optionals (cfg.user != null) ["--user" cfg.user]
    ++ cfg.extraArgs
    ;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "foldingAtHome" ] [ "services" "foldingathome" ])
    (lib.mkRenamedOptionModule [ "services" "foldingathome" "nickname" ] [ "services" "foldingathome" "user" ])
    (lib.mkRemovedOptionModule [ "services" "foldingathome" "config" ] ''
      Use <literal>services.foldingathome.extraArgs instead<literal>
    '')
  ];
  options.services.foldingathome = {
    enable = lib.mkEnableOption "Folding@home client";

    package = lib.mkPackageOption pkgs "fahclient" { };

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The user associated with the reported computation results. This will
        be used in the ranking statistics.
      '';
    };

    team = lib.mkOption {
      type = lib.types.int;
      default = 236565;
      description = ''
        The team ID associated with the reported computation results. This
        will be used in the ranking statistics.

        By default, use the NixOS folding@home team ID is being used.
      '';
    };

    daemonNiceLevel = lib.mkOption {
      type = lib.types.ints.between (-20) 19;
      default = 0;
      description = ''
        Daemon process priority for FAHClient.
        0 is the default Unix process priority, 19 is the lowest.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        Extra startup options for the FAHClient. Run
        `fah-client --help` to find all the available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.foldingathome = {
      description = "Folding@home client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        exec ${lib.getExe cfg.package} ${lib.escapeShellArgs args}
      '';
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "foldingathome";
        Nice = cfg.daemonNiceLevel;
        WorkingDirectory = "%S/foldingathome";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
