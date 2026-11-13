{
  name = "systemd-timesyncd";
  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { lib, ... }:
    {
      services.timesyncd = {
        enable = lib.mkForce true;
        servers = [ "ntp.example.com" ];
        fallbackServers = [ "fallback.example.com" ];
        settings.Time = {
          PollIntervalMaxSec = "180";
          RootDistanceMaxSec = "5";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("settings.Time renders timesyncd.conf"):
      machine.succeed("grep -F '[Time]' /etc/systemd/timesyncd.conf")
      machine.succeed("grep -F 'NTP=ntp.example.com' /etc/systemd/timesyncd.conf")
      machine.succeed("grep -F 'FallbackNTP=fallback.example.com' /etc/systemd/timesyncd.conf")
      machine.succeed("grep -F 'PollIntervalMaxSec=180' /etc/systemd/timesyncd.conf")
      machine.succeed("grep -F 'RootDistanceMaxSec=5' /etc/systemd/timesyncd.conf")
  '';
}
