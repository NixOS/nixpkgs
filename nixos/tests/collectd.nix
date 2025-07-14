{ pkgs, ... }:
{
  name = "collectd";
  meta = { };

  nodes.machine =
    { pkgs, lib, ... }:

    {
      services.collectd = {
        enable = true;
        extraConfig = lib.mkBefore ''
          Interval 30
        '';
        plugins = {
          rrdtool = ''
            DataDir "/var/lib/collectd/rrd"
          '';
          load = "";
        };
      };
      environment.systemPackages = [ pkgs.rrdtool ];
    };

  testScript = ''
    machine.wait_for_unit("collectd.service")
    hostname = machine.succeed("hostname").strip()
    file = f"/var/lib/collectd/rrd/{hostname}/load/load.rrd"
    machine.wait_for_file(file);
    machine.succeed(f"rrdinfo {file} | logger")
    # check that this file contains a shortterm metric
    machine.succeed(f"rrdinfo {file} | grep -F 'ds[shortterm].min = '")
    # check that interval was set before the plugins
    machine.succeed(f"rrdinfo {file} | grep -F 'step = 30'")
    # check that there are frequent updates
    machine.succeed(f"cp {file} before")
    machine.wait_until_fails(f"cmp before {file}")
  '';
}
