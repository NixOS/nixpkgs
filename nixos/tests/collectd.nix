import ./make-test-python.nix ({ pkgs, ... }: {
  name = "collectd";
  meta = { };

  machine =
    { pkgs, ... }:

    {
      services.collectd = {
        enable = true;
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
    # check that there are frequent updates
    machine.succeed(f"cp {file} before")
    machine.wait_until_fails(f"cmp before {file}")
  '';
})
