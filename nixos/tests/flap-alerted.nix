{ config, lib, ... }:

{
  name = "flap-alerted";
  meta.maintainers = with lib.maintainers; [ defelo ];

  nodes.machine = {
    services.flap-alerted = {
      enable = true;
      settings = {
        asn = 4213370001;
        bgpListenAddress = ":1790";
        routeChangeCounter = 5;
        overThresholdTarget = 1;
      };
    };

    services.bird = {
      enable = true;
      preCheckConfig = ''
        mkdir -p /tmp/bird
        touch /tmp/bird/routes.conf
      '';
      config = ''
        router id 192.168.1.1;

        protocol device { }

        protocol bgp flapalerted {
          local 2001:db8:1::1 as 4213370001;
          neighbor ::1 as 4213370001 port 1790;

          ipv4 {
            add paths on;
            export all;
            import none;
            extended next hop on;
          };

          ipv6 {
            add paths on;
            export all;
            import none;
          };
        }

        protocol static {
          include "/tmp/bird/routes.conf";

          ipv4 {
            import all;
            export none;
          };
        }
      '';
    };

    systemd.services.bird.serviceConfig.BindReadOnlyPaths = [ "/tmp/bird" ];

    systemd.tmpfiles.settings.bird-static-routes."/tmp/bird/routes.conf".f = { };
  };

  interactive.sshBackdoor.enable = true;
  interactive.defaults.virtualisation.graphics = false;

  interactive.nodes.machine = {
    services.flap-alerted.settings.httpAPIListenAddress = ":8699";
    networking.firewall.allowedTCPPorts = [ 8699 ];
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 8699;
        guest.port = 8699;
      }
    ];
  };

  testScript = ''
    import json
    import random
    import time

    machine.log(machine.succeed("systemd-analyze security flap-alerted.service --threshold=11 --no-pager"))

    machine.wait_for_unit("bird.service")
    machine.wait_for_unit("flap-alerted.service")
    machine.wait_for_open_port(1790)
    machine.wait_for_open_port(8699)

    resp = json.loads(machine.succeed("curl localhost:8699/capabilities"))
    expected_version = "v${config.nodes.machine.services.flap-alerted.package.version}"
    assert resp["Version"] == expected_version

    for _ in range(10):
      resp = json.loads(machine.succeed("curl localhost:8699/sessions"))
      if len(resp) == 1: break
      time.sleep(1)
    else:
      assert False, "failed to establish bgp session"
    assert resp[0]["RouterID"] == "192.168.1.1"

    resp = json.loads(machine.succeed("curl localhost:8699/flaps/active/compact"))
    assert resp == []

    def flap():
      route = lambda idx, gw: f"""
        route 10.0.{idx}.0/24 via 10.254.254.{gw} dev \"eth0\" onlink {{
          bgp_path.prepend(4213370002);
          bgp_path.prepend({4213370002 + gw});
        }};
      """
      with open("routes.conf", "w") as f:
        for i in range(1, 4): # stable routes
          f.write(route(i, i))
        for i in range(4, 7): # flappy routes
          f.write(route(i, random.randint(1, 254)))
      machine.copy_from_host("routes.conf", "/tmp/bird/routes.conf")
      machine.succeed("birdc configure")

    t = time.time()
    while time.time() - t < 70:
      flap()
      time.sleep(1)

    resp = json.loads(machine.succeed("curl localhost:8699/flaps/active/compact"))
    assert sorted(x["Prefix"] for x in resp) == ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  '';
}
