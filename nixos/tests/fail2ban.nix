import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "fail2ban";

    nodes.machine = _: {
      services.fail2ban = {
        enable = true;
        bantime-increment.enable = true;
      };

      services.openssh.enable = true;
    };

    testScript = ''
      machine.wait_for_unit("multi-user.target")

      machine.wait_for_unit("fail2ban")
    '';
  }
)
