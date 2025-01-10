import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
    sshPort = 8231;
    httpPort = 8232;
    statsPort = 8233;
    gitPort = 8418;
  in
  {
    name = "soft-serve";
    meta.maintainers = with lib.maintainers; [ dadada ];
    nodes = {
      client =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            curl
            git
            openssh
          ];
          environment.etc.sshKey = {
            source = snakeOilPrivateKey;
            mode = "0600";
          };
        };

      server =
        { config, ... }:
        {
          services.soft-serve = {
            enable = true;
            settings = {
              name = "TestServer";
              ssh.listen_addr = ":${toString sshPort}";
              git.listen_addr = ":${toString gitPort}";
              http.listen_addr = ":${toString httpPort}";
              stats.listen_addr = ":${toString statsPort}";
              initial_admin_keys = [ snakeOilPublicKey ];
            };
          };
          networking.firewall.allowedTCPPorts = [
            sshPort
            httpPort
            statsPort
          ];
        };
    };

    testScript =
      { ... }:
      ''
        SSH_PORT = ${toString sshPort}
        HTTP_PORT = ${toString httpPort}
        STATS_PORT = ${toString statsPort}
        KEY = "${snakeOilPublicKey}"
        SSH_KEY = "/etc/sshKey"
        SSH_COMMAND = f"ssh -p {SSH_PORT} -i {SSH_KEY} -o StrictHostKeyChecking=no"
        TEST_DIR = "/tmp/test"
        GIT = f"git -C {TEST_DIR}"

        for machine in client, server:
            machine.wait_for_unit("network.target")

        server.wait_for_unit("soft-serve.service")
        server.wait_for_open_port(SSH_PORT)

        with subtest("Get info"):
            status, test = client.execute(f"{SSH_COMMAND} server info")
            if status != 0:
                raise Exception("Failed to get SSH info")
            key = " ".join(KEY.split(" ")[0:2])
            if not key in test:
                raise Exception("Admin key must be configured correctly")

        with subtest("Create user"):
            client.succeed(f"{SSH_COMMAND} server user create beatrice")
            client.succeed(f"{SSH_COMMAND} server user info beatrice")

        with subtest("Create repo"):
            client.succeed(f"git init {TEST_DIR}")
            client.succeed(f"{GIT} config --global user.email you@example.com")
            client.succeed(f"touch {TEST_DIR}/foo")
            client.succeed(f"{GIT} add foo")
            client.succeed(f"{GIT} commit --allow-empty -m test")
            client.succeed(f"{GIT} remote add origin git@server:test")
            client.succeed(f"GIT_SSH_COMMAND='{SSH_COMMAND}' {GIT} push -u origin master")
            client.execute("rm -r /tmp/test")

        server.wait_for_open_port(HTTP_PORT)

        with subtest("Clone over HTTP"):
            client.succeed(f"curl --connect-timeout 10 http://server:{HTTP_PORT}/")
            client.succeed(f"git clone http://server:{HTTP_PORT}/test /tmp/test")
            client.execute("rm -r /tmp/test")

        with subtest("Clone over SSH"):
            client.succeed(f"GIT_SSH_COMMAND='{SSH_COMMAND}' git clone git@server:test /tmp/test")
            client.execute("rm -r /tmp/test")

        with subtest("Get stats over HTTP"):
            server.wait_for_open_port(STATS_PORT)
            status, test = client.execute(f"curl --connect-timeout 10 http://server:{STATS_PORT}/metrics")
            if status != 0:
                raise Exception("Failed to get metrics from status port")
            if not "go_gc_duration_seconds_count" in test:
                raise Exception("Metrics did not contain key 'go_gc_duration_seconds_count'")
      '';
  }
)
