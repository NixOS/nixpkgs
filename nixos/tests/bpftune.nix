import ./make-test-python.nix ({ lib, pkgs, ... }: {

  name = "bpftune";

  meta = {
    maintainers = with lib.maintainers; [ nickcao ];
  };

  nodes = {
    client = { pkgs, ... }: {
      services.bpftune.enable = true;

      boot.kernel.sysctl."net.ipv4.tcp_rmem" = "4096 131072 1310720";

      environment.systemPackages = [ pkgs.iperf3 ];
    };

    server = { ... }: {
      services.iperf3 = {
        enable = true;
        openFirewall = true;
      };
    };
  };

  testScript = ''
    with subtest("bpftune startup"):
      client.wait_for_unit("bpftune.service")
      client.wait_for_console_text("bpftune works fully")

    with subtest("bpftune tcp buffer size"):
      server.wait_for_unit("iperf3.service")
      client.succeed("iperf3 --reverse -c server")
      client.wait_for_console_text("need to increase TCP buffer size")
  '';

})
