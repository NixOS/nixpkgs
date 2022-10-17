import ./make-test-python.nix ({ ... }: {
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
          secretsfile.succeed("grep 'some-very-secret-string' /run/coturn/turnserver.cfg")
    '';
})
