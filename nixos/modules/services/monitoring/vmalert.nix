{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.vmalert;
  mkConfigFile =
    pkgs.writeText "rules.yaml" (lib.generators.toYAML { } cfg.configuration);

  checkedConfig = file:
    pkgs.runCommand "checked-config" { buildInputs = [ cfg.package ]; } ''
      ln -s ${file} $out
    '';

  vmalertRulesYAML = let
    yml = if cfg.configText != null then
      pkgs.writeText "rules.yaml" cfg.configText
    else
      mkConfigFile;
  in checkedConfig yml;

in {

  options.services.vmalert = with lib; {

    enable = mkEnableOption "vmalert";
    package = mkOption {
      type = types.package;
      default = pkgs.victoriametrics;
      defaultText = "pkgs.victoriametrics";
      description = ''
        The VictoriaMetrics distribution to use.
      '';
    };

    notifierUrls = mkOption {
      type = types.listOf types.str;
      default = [ "http://localhost:9093" ];
      description = ''
        AlertManager URL
      '';
    };

    remoteWriteUrl = mkOption {
      type = types.str;
      default = "http://localhost:8428";
      description = ''
        remote write compatible storage to persist rules
      '';
    };

    remoteReadUrl = mkOption {
      type = types.str;
      default = "http://localhost:8428";
      description = ''
        PromQL compatible datasource to restore alerts state from
      '';
    };

    dataSourceUrl = mkOption {
      type = types.str;
      default = "http://localhost:8428";
      description = ''
        PromQL compatible datasource
      '';
    };

    configuration = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = ''
        vmalert configuration as nix attribute set.
      '';
    };

    configText = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Test
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra options to pass to Victoriametrics Alert. See the README: <link
        xlink:href="https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/app/vmalert/README.md" />
        or <command>vmalert -help</command> for more
        information.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.vmalert = {
      description = "vmalert";
      after = [ "network.target" ];
      preStart = ''
        cp "${vmalertRulesYAML}" "/tmp/rules.yaml"
      '';
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 1;
        StartLimitBurst = 5;
        StateDirectory = "vmalert";
        DynamicUser = true;
        ExecStart = ''
          ${cfg.package}/bin/vmalert -rule /tmp/rules.yaml ${
            lib.concatMapStrings
            (notifierUrl: "-notifier.url=${toString notifierUrl}")
            cfg.notifierUrls
          } -datasource.url=${toString cfg.dataSourceUrl} -remoteWrite.url=${
            toString cfg.remoteWriteUrl
          } -remoteRead.url=${toString cfg.remoteReadUrl} ${
            lib.escapeShellArgs cfg.extraOptions
          }
        '';
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
