import ./make-test-python.nix ({ pkgs, ... }: {
  name = "coturn";
  nodes = {
    default = {
      services.coturn.enable = true;
    };
    secretsfile = {
      boot.postBootCommands = ''
        echo "some-very-secret-string" > /run/coturn-secret
      '';
      services.coturn = {
        enable = true;
        static-auth-secret-file = "/run/coturn-secret";
      };
    };
  };

  testScript =
    ''
      start_all()

      with subtest("by default works without configuration"):
          default.wait_for_unit("coturn.service")

      with subtest("works with static-auth-secret-file"):
          secretsfile.wait_for_unit("coturn.service")
          secretsfile.wait_for_open_port(3478)
          secretsfile.succeed("grep 'some-very-secret-string' /run/coturn/turnserver.cfg")
          # Forbidden IP, fails:
          secretsfile.fail("${pkgs.coturn}/bin/turnutils_uclient -W some-very-secret-string 127.0.0.1 -DgX -e 127.0.0.1 -n 1 -c -y")
          # allowed-peer-ip, should succeed:
          secretsfile.succeed("${pkgs.coturn}/bin/turnutils_uclient -W some-very-secret-string 192.168.1.2 -DgX -e 192.168.1.2 -n 1 -c -y")
    '';
})
