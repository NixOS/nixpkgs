{ config, ... }:
let
  banFor = name: duration: {
    ban = {
      type = "ipset";
      options = {
        set = "reaction-${name}";
        action = "add";
      };
    };
    unban = {
      after = duration;
      type = "ipset";
      options = {
        set = "reaction-${name}";
        action = "del";
      };
    };
  };

  journalctl = "${config.systemd.package}/bin/journalctl";
in
{
  patterns = {
    ip = {
      type = "ip";
      ipv6mask = 64;
      ignore = [
        "127.0.0.1"
        "::1"
      ];
      ignorecidr = [
        "10.1.1.0/24"
        "2a01:e0a:b3a:1dd0::/64"
      ];
    };
  };

  streams = {
    ssh = {
      cmd = [
        journalctl
        "-fn0"
        "-o"
        "cat"
        "-u"
        "sshd.service"
      ];
      filters = {
        failedlogin = {
          regex = [
            "authentication failure;.*rhost=<ip>(?: |$)"
            "Failed password for .* from <ip> port"
            "Invalid user .* from <ip> "
            "Connection (?:reset|closed) by invalid user .* <ip> port"
          ];
          retry = 2;
          retryperiod = "6h";
          actions = banFor "ssh" "48h";
        };
        connectionreset = {
          regex = [
            "Connection (?:reset|closed) by(?: authenticating user .*)? <ip> port"
            "Received disconnect from <ip> port .*[preauth]"
            "Timeout before authentication for connection from <ip> to"
          ];
          retry = 2;
          retryperiod = "6h";
          actions = banFor "sshreset" "48h";
        };
      };
    };
  };
}
