import ../make-test-python.nix (
  { ... }:

  {
    name = "pam-u2f";

    nodes.machine =
      { ... }:
      {
        security.pam.u2f = {
          control = "required";
          cue = true;
          debug = true;
          enable = true;
          interactive = true;
          origin = "nixos-test";
        };
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed(
          'egrep "auth required .*/lib/security/pam_u2f.so.*cue.*debug.*interactive.*origin=nixos-test" /etc/pam.d/ -R'
      )
    '';
  }
)
