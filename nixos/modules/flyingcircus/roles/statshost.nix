# statshost: an InfluxDB/Grafana server. Accepts incoming graphite traffic,
# stores it and renders graphs.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.flyingcircus;

  # can be replaced with pkgs.influxdb once InfluxDB 0.11 is present in upstream
  # nixpkgs.
  influxdb = (pkgs.callPackage ../packages/influxdb.nix { }).bin //
    { outputs = [ "bin" ]; };

in
{
  options = {
    flyingcircus.roles.statshost = {
      enable = mkEnableOption "stats host";

      hostName = mkOption {
        type = types.str;
        default = "";
        description = "HTTP host name for the stats frontend. Must be set.";
        example = "stats.example.com";
      };
    };
  };

  config = mkIf cfg.roles.statshost.enable {

    # make the 'influx' command line tool accessible
    environment.systemPackages = [ influxdb ];

    services.influxdb011.enable = true;
    services.influxdb011.dataDir = "/srv/influxdb";
    services.influxdb011.package = influxdb;
    services.influxdb011.extraConfig = {
         http.enabled = true;
         http.auth-enabled = false;

         graphite = [
          { enabled = true;
            protocol = "udp";
            udp-read-buffer = 8388608;
            templates = [
              # new hierarchy
              "fcio.*.*.*.*.*.ceph .location.resourcegroup.machine.profile.host.measurement.instance..field"
              "fcio.*.*.*.*.*.cpu  .location.resourcegroup.machine.profile.host.measurement.instance..field"
              "fcio.*.*.*.*.*.load .location.resourcegroup.machine.profile.host.measurement..field"
              "fcio.*.*.*.*.*.netlink .location.resourcegroup.machine.profile.host.measurement.instance.field*"
              "fcio.*.*.*.*.*.entropy .location.resourcegroup.machine.profile.host.measurement.field"
              "fcio.*.*.*.*.*.swap .location.resourcegroup.machine.profile.host.measurement..field"
              "fcio.*.*.*.*.*.uptime .location.resourcegroup.machine.profile.host.measurement.field"
              "fcio.*.*.*.*.*.processes .location.resourcegroup.machine.profile.host.measurement.field*"
              "fcio.*.*.*.*.*.users .location.resourcegroup.machine.profile.host.measurement.field"
              "fcio.*.*.*.*.*.vmem .location.resourcegroup.machine.profile.host.measurement..field"
              "fcio.*.*.*.*.*.disk .location.resourcegroup.machine.profile.host.measurement.instance.field*"
              "fcio.*.*.*.*.*.interface .location.resourcegroup.machine.profile.host.measurement.instance.field*"
              # Generic collectd plugin: measurement/instance/field (i.e. load/loadl/longtermn)
              "fcio.* .location.resourcegroup.machine.profile.host.measurement.field*"

              # old hierarchy
              "fcio.*.*.*.ceph .location.resourcegroup.host.measurement.instance..field"
              "fcio.*.*.*.cpu  .location.resourcegroup.host.measurement.instance..field"
              "fcio.*.*.*.load .location.resourcegroup.host.measurement..field"
              "fcio.*.*.*.netlink .location.resourcegroup.host.measurement.instance.field*"
              "fcio.*.*.*.entropy .location.resourcegroup.host.measurement.field"
              "fcio.*.*.*.swap .location.resourcegroup.host.measurement..field"
              "fcio.*.*.*.uptime .location.resourcegroup.host.measurement.field"
              "fcio.*.*.*.processes .location.resourcegroup.host.measurement.field*"
              "fcio.*.*.*.users .location.resourcegroup.host.measurement.field"
              "fcio.*.*.*.vmem .location.resourcegroup.host.measurement..field"
              "fcio.*.*.*.disk .location.resourcegroup.host.measurement.instance.field*"
              "fcio.*.*.*.interface .location.resourcegroup.host.measurement.instance.field*"
            ];
          }
        ];
    };

    boot.kernel.sysctl = {
      "net.core.rmem_max" = 8388608;
    };

    services.grafana = {
      enable = true;
      port = 3001;
      addr = "127.0.0.1";
      rootUrl = "http://${cfg.roles.statshost.hostName}/grafana";
    };

    services.nginx.enable = true;
    services.nginx.httpConfig = ''
      server {
          listen *:80;
          server_name ${cfg.roles.statshost.hostName};

          location / {
              rewrite . /grafana/ redirect;
          }

          location /grafana/ {
              proxy_pass http://localhost:3001/;
          }

          location /grafana/public {
              alias ${config.services.grafana.staticRootPath};
          }
      }
    '';

    networking.firewall.allowedTCPPorts = [ 80 443 2003 8083 8086 ];
    networking.firewall.allowedUDPPorts = [ 2003 ];
  };
}

# vim: set sw=2 et:
