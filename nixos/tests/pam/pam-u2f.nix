import ../make-test-python.nix (
  { ... }:

  {
    name = "pam-u2f";

    nodes.machine =
      { ... }:
      {
        security.pam.u2f = {
          enable = true;
          control = "required";
          settings = {
            cue = true;
            debug = true;
            interactive = true;
            origin = "nixos-test";
            # Freeform option
            userpresence = 1;
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed(
          'egrep "auth required .*/lib/security/pam_u2f.so.*cue.*debug.*interactive.*origin=nixos-test.*userpresence=1" /etc/pam.d/ -R'
      )
    '';
  }
)
