{ pkgs, lib, ... }:
let
  # opensnitch ebpf seems to handle non-x86 syscalls incorrectly
  test_ebpf = pkgs.stdenv.hostPlatform.isx86;

  monitorMethods = [
    "proc"
    "ftrace"
    "audit"
  ]
  ++ lib.optional test_ebpf "ebpf";
in
{
  name = "opensnitch";

  meta = with pkgs.lib.maintainers; {
    maintainers = [
      onny
      grimmauld
    ];
  };

  nodes = {
    server = {
      networking.firewall.allowedTCPPorts = [ 80 ];
      services.caddy = {
        enable = true;
        virtualHosts."localhost".extraConfig = ''
          respond "Hello, world!"
        '';
      };
    };
  }
  // (lib.listToAttrs (
    map (
      m:
      lib.nameValuePair "client_blocked_${m}" {
        services.opensnitch = {
          enable = true;
          settings.DefaultAction = "deny";
          settings.ProcMonitorMethod = m;
          settings.LogLevel = 1;
        };
      }
    ) monitorMethods
  ))
  // (lib.listToAttrs (
    map (
      m:
      lib.nameValuePair "client_allowed_${m}" {
        services.opensnitch = {
          enable = true;
          settings.DefaultAction = "deny";
          settings.ProcMonitorMethod = m;
          settings.LogLevel = 1;
          rules = {
            curl = {
              name = "curl";
              enabled = true;
              action = "allow";
              duration = "always";
              operator = {
                type = "list";
                operand = "list";
                list = [
                  {
                    type = "simple";
                    sensitive = false;
                    operand = "process.path";
                    data = "${pkgs.curl}/bin/curl";
                  }
                  # Check that network aliases like "LAN" are properly resolved.
                  {
                    type = "network";
                    sensitive = false;
                    operand = "dest.network";
                    data = "LAN";
                  }
                ];
              };
            };
          };
        };
      }
    ) monitorMethods
  ));

  testScript = ''
    start_all()
    server.wait_for_unit("caddy.service")
    server.wait_for_open_port(80)
  ''
  + (
    lib.concatLines (
      map (m: ''
        client_blocked_${m}.wait_for_unit("opensnitchd.service")
        client_blocked_${m}.fail("curl --connect-timeout 3 http://server")

        client_allowed_${m}.wait_for_unit("opensnitchd.service")
        client_allowed_${m}.succeed("curl --connect-timeout 3 http://server")
      '') monitorMethods
    )
    + lib.optionalString test_ebpf ''
      # make sure the kernel modules were actually properly loaded
      client_blocked_ebpf.succeed(r"journalctl -u opensnitchd --grep '\[eBPF\] module loaded: /nix/store/.*/etc/opensnitchd/opensnitch\.o'")
      client_blocked_ebpf.succeed(r"journalctl -u opensnitchd --grep '\[eBPF\] module loaded: /nix/store/.*/etc/opensnitchd/opensnitch-procs\.o'")
      client_blocked_ebpf.succeed(r"journalctl -u opensnitchd --grep '\[eBPF\] module loaded: /nix/store/.*/etc/opensnitchd/opensnitch-dns\.o'")
      client_allowed_ebpf.succeed(r"journalctl -u opensnitchd --grep '\[eBPF\] module loaded: /nix/store/.*/etc/opensnitchd/opensnitch\.o'")
      client_allowed_ebpf.succeed(r"journalctl -u opensnitchd --grep '\[eBPF\] module loaded: /nix/store/.*/etc/opensnitchd/opensnitch-procs\.o'")
      client_allowed_ebpf.succeed(r"journalctl -u opensnitchd --grep '\[eBPF\] module loaded: /nix/store/.*/etc/opensnitchd/opensnitch-dns\.o'")
    ''
  );
}
