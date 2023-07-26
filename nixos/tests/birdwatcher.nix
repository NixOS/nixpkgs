# This test does a basic functionality check for birdwatcher

{ system ? builtins.currentSystem
, pkgs ? import ../.. { inherit system; config = { }; }
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  inherit (pkgs.lib) optionalString;
in
makeTest {
  name = "birdwatcher";
  nodes = {
    host1 = {
      environment.systemPackages = with pkgs; [ jq ];
      services.bird2 = {
        enable = true;
        config = ''
          log syslog all;

          debug protocols all;

          router id 10.0.0.1;

          protocol device {
          }

          protocol kernel kernel4 {
            ipv4 {
              import none;
              export all;
            };
          }

          protocol kernel kernel6 {
            ipv6 {
              import none;
              export all;
            };
          }
        '';
      };
      services.birdwatcher = {
        enable = true;
        settings = ''
          [server]
          allow_from = []
          allow_uncached = false
          modules_enabled = ["status",
                             "protocols",
                             "protocols_bgp",
                             "protocols_short",
                             "routes_protocol",
                             "routes_peer",
                             "routes_table",
                             "routes_table_filtered",
                             "routes_table_peer",
                             "routes_filtered",
                             "routes_prefixed",
                             "routes_noexport",
                             "routes_pipe_filtered_count",
                             "routes_pipe_filtered"
                            ]
          [status]
          reconfig_timestamp_source = "bird"
          reconfig_timestamp_match = "# created: (.*)"
          filter_fields = []
          [bird]
          listen = "0.0.0.0:29184"
          config = "/etc/bird/bird2.conf"
          birdc  = "${pkgs.bird}/bin/birdc"
          ttl = 5 # time to live (in minutes) for caching of cli output
          [parser]
          filter_fields = []
          [cache]
          use_redis = false # if not using redis cache, activate housekeeping to save memory!
          [housekeeping]
          interval = 5
          force_release_memory = true
        '';
      };
    };
  };

  testScript = ''
    start_all()

    host1.wait_for_unit("bird2.service")
    host1.wait_for_unit("birdwatcher.service")
    host1.wait_for_open_port(29184)
    host1.succeed("curl http://[::]:29184/status | jq -r .status.message | grep 'Daemon is up and running'")
    host1.succeed("curl http://[::]:29184/protocols | jq -r .protocols.device1.state | grep 'up'")
  '';
}
