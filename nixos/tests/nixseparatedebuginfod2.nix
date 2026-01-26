{ pkgs, lib, ... }:
{
  name = "nixseparatedebuginfod2";
  # A binary cache with debug info and source for gnumake
  nodes.cache =
    { pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        virtualHosts.default = {
          default = true;
          addSSL = false;
          root = "/var/lib/thebinarycache";
        };
      };
      networking.firewall.allowedTCPPorts = [ 80 ];
      systemd.services.buildthebinarycache = {
        before = [ "nginx.service" ];
        wantedBy = [ "nginx.service" ];
        script = ''
          ${pkgs.nix}/bin/nix --extra-experimental-features nix-command copy --to file:///var/lib/thebinarycache?index-debug-info=true ${pkgs.gnumake.debug} ${pkgs.gnumake} ${pkgs.gnumake.src} ${pkgs.sl}
        '';
        serviceConfig = {
          User = "nginx";
          Group = "nginx";
          StateDirectory = "thebinarycache";
          Type = "oneshot";
        };
      };
    };
  # the machine where we need the debuginfo
  nodes.machine = {
    services.nixseparatedebuginfod2 = {
      enable = true;
      substituters = [ "http://cache" ];
    };
    environment.systemPackages = [
      pkgs.valgrind
      pkgs.gdb
      pkgs.gnumake
    ];
  };
  testScript = ''
    start_all()
    cache.wait_for_unit("nginx.service")
    cache.wait_for_open_port(80)
    machine.wait_for_unit("nixseparatedebuginfod2.service")
    machine.wait_for_open_port(1949)

    with subtest("check that the binary cache works"):
      machine.succeed("nix-store --extra-substituters http://cache --option require-sigs false -r ${pkgs.sl}")

    # test debuginfod-find
    machine.succeed("debuginfod-find debuginfo /run/current-system/sw/bin/make")

    # test that gdb can fetch source
    out = machine.succeed("gdb /run/current-system/sw/bin/make --batch -x ${builtins.toFile "commands" ''
      start
      l
    ''}")
    print(out)
    assert 'main (int argc, char **argv, char **envp)' in out

    # test that valgrind can display location information
    # this relies on the fact that valgrind complains about gnumake
    # because we also ask valgrind to show leak kinds
    # which are usually false positives.
    out = machine.succeed("valgrind --leak-check=full --show-leak-kinds=all make --version 2>&1")
    print(out)
    assert 'main.c' in out
  '';
}
