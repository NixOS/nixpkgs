{ pkgs, lib, ... }:

{
  name = "pulseaudio-tcp";

  meta.maintainers =
    pkgs.pulseaudio.meta.maintainers
    ++ (with lib.maintainers; [
      aleksana
      doronbehar
    ]);

  nodes = {
    server = {
      virtualisation.vlans = [ 1 ];

      networking.useNetworkd = true;

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.1/24";
      };

      services.pulseaudio = {
        enable = true;
        tcp = {
          enable = true;
          port = 4713;
          openFirewall = true;
          anonymousClients.allowedIpRanges = [ "10.0.0.2" ];
        };
        systemWide = true;
        extraConfig = ''
          load-module module-pipe-sink file=/tmp/audio_check sink_name=virtual_server_sink
          set-default-sink virtual_server_sink
        '';
      };

      systemd.services.pulseaudio.wantedBy = [ "multi-user.target" ];
    };
    client = {
      virtualisation.vlans = [ 1 ];

      networking.useNetworkd = true;

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.2/24";
      };

      services.pulseaudio = {
        enable = true;
        extraClientConf = ''
          default-server = tcp:10.0.0.1:4713
        '';
      };
    };
  };

  testScript = # python
    ''
      start_all()
      server.wait_for_unit("pulseaudio.service")

      # port is open
      server.wait_for_open_port(4713)
      client.wait_for_open_port(4713, "10.0.0.1")

      # client can see server
      client.succeed('pactl info | grep "Server String" | grep -q "tcp"')
      client.succeed('pactl list sinks short | grep -q "virtual_server_sink"')

      # server sink pipe is in place
      server.succeed('[ -e "/tmp/audio_check" ]')

      # try to read something from it, it should not work as we haven't played anything
      server.fail('timeout 1s head -c 1 /tmp/audio_check')

      # client start to play something
      client.execute("pacat -p --latency-msec=100 --channels=1 /dev/zero >/dev/null 2>&1 &")

      server.sleep(1)

      # server sink has received data now, in a normal setup it should be able to play
      server.succeed('timeout 1s head -c 100 /tmp/audio_check')
    '';
}
