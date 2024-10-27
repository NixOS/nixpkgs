{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:

pkgs.testers.runNixOSTest {
  name = "postgresql-listen-addresses";
  # Test that PostgreSQL defaults to "localhost" when enableTCPIP = true.

  nodes = {
    default = { pkgs, lib, ... }: {
      # Default behaviour of the service
      services.postgresql = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        lsof
      ];
    };
    listenall = { pkgs, lib, ... }: {
      services.postgresql = {
        enable = true;
        listenAddresses = "0.0.0.0";
        enableTCPIP = true;
        # settings.listen_addresses = "0.0.0.0";
      };
      environment.systemPackages = with pkgs; [
        lsof
      ];
    };
    unixonly = { pkgs, lib, ... }: {
      services.postgresql = {
        enable = true;
        enableTCPIP = false;
      };
      environment.systemPackages = with pkgs; [
        lsof
      ];
    };
  };

  testScript = ''
    machines = [ default, listenall, unixonly ]

    for machine in machines:
        machine.start()
        machine.wait_for_unit("postgresql.service")

    with subtest("Configured to listen on localhost"):
        default.succeed(
            "sudo -u postgres psql <<<'SHOW listen_addresses' 2>/dev/null | grep 'localhost'")

    with subtest("Actually listening on localhost"):
        output = default.succeed("lsof -i tcp -P | grep 'localhost:5432'")

    with subtest("Configured to listen on localhost"):
        listenall.succeed(
            "sudo -u postgres psql <<<'SHOW listen_addresses' 2>/dev/null | grep '0.0.0.0'")

    with subtest("Actually listening on localhost"):
        listenall.succeed("lsof -i tcp -P | grep '*:5432'")

    with subtest("Configured not to listen on localhost or 0.0.0.0"):
        unixonly.fail(
            "sudo -u postgres psql <<<'SHOW listen_addresses' 2>/dev/null | grep 'localhost'")
        unixonly.fail(
            "sudo -u postgres psql <<<'SHOW listen_addresses' 2>/dev/null | grep '0.0.0.0'")

    with subtest("Actually not listening on TCP"):
        unixonly.fail("lsof -i tcp -P | grep ':5432'")

    for machine in machines:
        machine.shutdown()
  '';
}
