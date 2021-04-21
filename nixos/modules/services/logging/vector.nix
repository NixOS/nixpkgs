{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.vector;

in
{
  options.services.vector = {
    enable = mkEnableOption "Vector";

    journaldAccess = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable Vector to access journald.
      '';
    };

    afterServices = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "loki.service" "systemd-journald.service" ];
      description = ''
        Your vector topology might depend on other services being started.
      '';
    };

    settings = mkOption {
      type = (pkgs.formats.json { }).type;
      default = { };
      description = ''
        Specify the configuration for Vector in Nix.
      '';
    };
  };

  config = mkIf cfg.enable {

    users.groups.vector = { };
    users.users.vector = {
      description = "Vector service user";
      group = "vector";
      isSystemUser = true;
    };
    systemd.services.vector = {
      description = "Vector event and log aggregator";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ] ++ cfg.settings.afterServices;
      requires = [ "network-online.target" ] ++ cfg.settings.afterServices;
      serviceConfig =
        let
          format = pkgs.formats.toml { };
          conf = format.generate "vector.toml" cfg.settings;
          validateConfig = file:
            pkgs.runCommand "validate-vector-conf" { } ''
              ${pkgs.vector}/bin/vector validate --no-environment "${file}"
              ln -s "${file}" "$out"
            '';
        in
        {
          ExecStart = "${pkgs.vector}/bin/vector --config ${validateConfig conf}";
          User = "vector";
          Group = "vector";
          Restart = "no";
          StateDirectory = "vector";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          # This group is required for accessing journald.
          SupplementaryGroups = mkIf cfg.journaldAccess "systemd-journal";
        };
    };
  };
}
