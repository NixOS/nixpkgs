{ pkgs, lib, ... }:
let
  monitorMethods = [
    "ebpf"
    "proc"
    "ftrace"
    "audit"
  ];
in
{
  name = "opensnitch";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ onny ];
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
                type = "simple";
                sensitive = false;
                operand = "process.path";
                data = "${pkgs.curl}/bin/curl";
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
        client_blocked_${m}.fail("curl http://server")

        client_allowed_${m}.wait_for_unit("opensnitchd.service")
        client_allowed_${m}.succeed("curl http://server")
      '') monitorMethods
    )
    + ''
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
