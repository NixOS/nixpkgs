{ pkgs, lib, ... }:

{
  name = "fastnetmon-advanced";
  meta.maintainers = lib.teams.wdz.members;

  nodes = {
    bird =
      { ... }:
      {
        networking.firewall.allowedTCPPorts = [ 179 ];
        services.bird2 = {
          enable = true;
          config = ''
            router id 192.168.1.1;

            protocol bgp fnm {
              local 192.168.1.1 as 64513;
              neighbor 192.168.1.2 as 64514;
              multihop;
              ipv4 {
                import all;
                export none;
              };
            }
          '';
        };
      };
    fnm =
      { ... }:
      {
        networking.firewall.allowedTCPPorts = [ 179 ];
        services.fastnetmon-advanced = {
          enable = true;
          settings = {
            networks_list = [ "172.23.42.0/24" ];
            gobgp = true;
            gobgp_flow_spec_announces = true;
          };
          bgpPeers = {
            bird = {
              local_asn = 64514;
              remote_asn = 64513;
              local_address = "192.168.1.2";
              remote_address = "192.168.1.1";

              description = "Bird";
              ipv4_unicast = true;
              multihop = true;
              active = true;
            };
          };
        };
      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()
      fnm.wait_for_unit("fastnetmon.service")
      bird.wait_for_unit("bird2.service")

      fnm.wait_until_succeeds('journalctl -eu fastnetmon.service | grep "BGP daemon restarted correctly"')
      fnm.wait_until_succeeds("journalctl -eu gobgp.service | grep BGP_FSM_OPENCONFIRM")
      bird.wait_until_succeeds("birdc show protocol fnm | grep Estab")
      fnm.wait_until_succeeds('journalctl -eu fastnetmon.service | grep "API server listening"')
      fnm.succeed("fcli set blackhole 172.23.42.123")
      bird.succeed("birdc show route | grep 172.23.42.123")
    '';
}
