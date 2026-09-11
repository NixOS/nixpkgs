{ lib, pkgs, ... }:

{
  name = "kvrocks";
  meta.maintainers = with lib.maintainers; [ xyenon ];

  nodes.machine = {
    services.kvrocks = {
      enable = true;
      settings.log-level = "debug";
    };

    specialisation."nonDefaultDataDir".configuration = {
      services.kvrocks.settings.dir = "/var/lib/kvrocks-custom";
    };

    specialisation."unixSocket".configuration = {
      services.kvrocks.settings.bind = [ ];
      services.kvrocks.settings.unixsocket = "/run/kvrocks/kvrocks.sock";
    };

    specialisation."tcpAndUnix".configuration = {
      services.kvrocks.settings.unixsocket = "/run/kvrocks/kvrocks.sock";
    };

    specialisation."socketActivation".configuration = {
      services.kvrocks = {
        socketActivation = true;
        settings.bind = [ "127.0.0.1" ];
      };
    };

    specialisation."socketActivationAndUnix".configuration = {
      services.kvrocks = {
        socketActivation = true;
        settings = {
          bind = [ "127.0.0.1" ];
          unixsocket = "/run/kvrocks/kvrocks.sock";
        };
      };
    };
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.services) kvrocks;
      port = toString kvrocks.settings.port;
      redisCliTcp = "${pkgs.redis}/bin/redis-cli -p ${port}";
      unixsocket = "/run/kvrocks/kvrocks.sock";
      redisCliUnix = "${pkgs.redis}/bin/redis-cli -s ${unixsocket}";
      switchTo =
        name:
        "${nodes.machine.system.build.toplevel}/specialisation/${name}/bin/switch-to-configuration test";
    in
    ''
      start_all()
      machine.wait_for_unit("kvrocks.service")
      machine.wait_for_open_port(${port})
      machine.succeed("${redisCliTcp} ping | grep PONG")

      with subtest("Test normal usage"):
        machine.succeed("${redisCliTcp} set k1 v1 | grep OK")
        machine.succeed("${redisCliTcp} get k1 | grep v1")
        machine.systemctl("restart kvrocks")
        machine.wait_for_unit("kvrocks.service")
        machine.wait_for_open_port(${port})
        machine.succeed("${redisCliTcp} get k1 | grep v1")

      with subtest("Test usage with non-default data directory"):
        machine.succeed("${switchTo "nonDefaultDataDir"}")
        machine.wait_for_unit("kvrocks.service")
        machine.wait_for_open_port(${port})
        machine.succeed("test -d /var/lib/kvrocks-custom")
        machine.succeed("${redisCliTcp} set k2 v2 | grep OK")
        machine.succeed("${redisCliTcp} get k2 | grep v2")
        machine.systemctl("restart kvrocks")
        machine.wait_for_unit("kvrocks.service")
        machine.wait_for_open_port(${port})
        machine.succeed("${redisCliTcp} get k2 | grep v2")

      with subtest("Test usage with unix socket only"):
        machine.succeed("${switchTo "unixSocket"}")
        machine.wait_for_unit("kvrocks.service")
        machine.wait_for_file("${unixsocket}")
        machine.succeed("${redisCliUnix} set k3 v3 | grep OK")
        machine.succeed("${redisCliUnix} get k3 | grep v3")
        machine.systemctl("restart kvrocks")
        machine.wait_for_unit("kvrocks.service")
        machine.wait_for_file("${unixsocket}")
        machine.succeed("${redisCliUnix} get k3 | grep v3")

      with subtest("Test usage with TCP and unix socket"):
        machine.succeed("${switchTo "tcpAndUnix"}")
        machine.wait_for_unit("kvrocks.service")
        machine.wait_for_open_port(${port})
        machine.wait_for_file("${unixsocket}")
        machine.succeed("${redisCliTcp} set k4 v4 | grep OK")
        machine.succeed("${redisCliTcp} get k4 | grep v4")
        machine.succeed("${redisCliUnix} get k4 | grep v4")

      with subtest("Test usage with socket activation"):
        machine.succeed("${switchTo "socketActivation"}")
        machine.wait_for_unit("kvrocks.socket")
        machine.wait_until_succeeds("${redisCliTcp} ping | grep PONG")
        machine.wait_for_unit("kvrocks.service")
        machine.wait_for_open_port(${port})
        machine.succeed("${redisCliTcp} set k5 v5 | grep OK")
        machine.succeed("${redisCliTcp} get k5 | grep v5")

      with subtest("Test usage with socket activation and unix socket"):
        machine.succeed("${switchTo "socketActivationAndUnix"}")
        machine.wait_for_unit("kvrocks.socket")
        machine.wait_until_succeeds("${redisCliTcp} ping | grep PONG")
        machine.wait_for_unit("kvrocks.service")
        machine.wait_for_open_port(${port})
        machine.wait_for_file("${unixsocket}")
        machine.succeed("${redisCliTcp} set k6 v6 | grep OK")
        machine.succeed("${redisCliTcp} get k6 | grep v6")
        machine.succeed("${redisCliUnix} get k6 | grep v6")
    '';
}
