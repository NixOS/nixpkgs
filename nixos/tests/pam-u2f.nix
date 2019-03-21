import ./make-test.nix ({ ... }:

{
  name = "pam-u2f";

  machine =
    { ... }:
    {
      security.pam.u2f = {
        control = "required";
        cue = true;
        debug = true;
        enable = true;
        interactive = true;
      };
    };

  testScript =
    ''
      $machine->waitForUnit('multi-user.target');
      $machine->succeed('egrep "auth required .*/lib/security/pam_u2f.so.*debug.*interactive.*cue" /etc/pam.d/ -R');
    '';
})
