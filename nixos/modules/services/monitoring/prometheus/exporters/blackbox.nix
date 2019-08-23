{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.blackbox;

  checkConfig = file: pkgs.runCommand "checked-blackbox-exporter.conf" {
    preferLocalBuild = true;
    buildInputs = [ pkgs.buildPackages.prometheus-blackbox-exporter ]; } ''
    ln -s ${file} $out
    blackbox_exporter --config.check --config.file $out
  '';
in
{
  port = 9115;
  extraOpts = {
    configFile = mkOption {
      type = types.path;
      description = ''
        Path to configuration file.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_RAW" ]; # for ping probes
      ExecStart = ''
        ${pkgs.prometheus-blackbox-exporter}/bin/blackbox_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --config.file ${checkConfig cfg.configFile} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    };
  };
}
