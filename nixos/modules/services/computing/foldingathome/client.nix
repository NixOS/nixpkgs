{ config, lib, pkgs, ... }:
with lib;
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
    (mkRenamedOptionModule [ "services" "foldingAtHome" ] [ "services" "foldingathome" ])
    (mkRenamedOptionModule [ "services" "foldingathome" "nickname" ] [ "services" "foldingathome" "user" ])
    (mkRemovedOptionModule [ "services" "foldingathome" "config" ] ''
      Use <literal>services.foldingathome.extraArgs instead<literal>
    '')
  ];
  options.services.foldingathome = {
    enable = mkEnableOption (lib.mdDoc "Folding@home client");

    package = mkPackageOption pkgs "fahclient" { };

    user = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        The user associated with the reported computation results. This will
        be used in the ranking statistics.
      '';
    };

    team = mkOption {
      type = types.int;
      default = 236565;
      description = lib.mdDoc ''
        The team ID associated with the reported computation results. This
        will be used in the ranking statistics.

        By default, use the NixOS folding@home team ID is being used.
      '';
    };

    daemonNiceLevel = mkOption {
      type = types.ints.between (-20) 19;
      default = 0;
      description = lib.mdDoc ''
        Daemon process priority for FAHClient.
        0 is the default Unix process priority, 19 is the lowest.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Extra startup options for the FAHClient. Run
        `fah-client --help` to find all the available options.
      '';
    };
  };

  config = mkIf cfg.enable {
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
