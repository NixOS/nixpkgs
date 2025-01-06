# This test runs influxdb and checks if influxdb is up and running

import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "influxdb";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ offline ];
    };

    nodes = {
      one =
        { ... }:
        {
          services.influxdb.enable = true;
          environment.systemPackages = [ pkgs.httpie ];
        };
    };

    testScript = ''
      import shlex

      start_all()

      one.wait_for_unit("influxdb.service")

      # create database
      one.succeed(
          "curl -XPOST http://localhost:8086/query --data-urlencode 'q=CREATE DATABASE test'"
      )

      # write some points and run simple query
      out = one.succeed(
          "curl -XPOST 'http://localhost:8086/write?db=test' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'"
      )

      qv = "SELECT value FROM cpu_load_short WHERE region='us-west'"
      cmd = f'curl -GET "http://localhost:8086/query?db=test" --data-urlencode {shlex.quote("q="+ qv)}'
      out = one.succeed(cmd)

      assert "2015-06-11T20:46:02Z" in out
      assert "0.64" in out
    '';
  }
)
