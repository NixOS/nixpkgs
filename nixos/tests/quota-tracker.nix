{ pkgs, ... }:

{
  name = "quota-tracker";
  meta = {
    maintainers = [ pkgs.lib.maintainers.Thomas97460 ];
  };

  nodes.machine = {
    imports = [ ./common/user-account.nix ];
    services.quota-tracker = {
      enable = true;
      host = "127.0.0.1";
      port = 9898;
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # The service is a user service, so we need to start the user manager
    machine.execute("loginctl enable-linger alice")
    machine.systemctl("start user@1000")

    # Wait for the user service to start
    machine.wait_for_unit("quota-tracker.service", "alice")

    # Check if the binary is available and works
    machine.succeed("sudo -u alice ${pkgs.quota-tracker}/bin/quota-tracker --help")

    # Check if the daemon is listening on its configured port 9898
    machine.wait_for_open_port(9898)
    machine.succeed("curl -f http://127.0.0.1:9898/api/version")
  '';
}
