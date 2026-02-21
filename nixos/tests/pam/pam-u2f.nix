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
      security.pam.services.login.u2f.enable = false;
      security.pam.services.sudo.u2f.control = "sufficient";
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed(
        'egrep "auth required .*/lib/security/pam_u2f.so.*cue.*debug.*interactive.*origin=nixos-test.*userpresence=1" /etc/pam.d/ -R'
    )
    machine.fail(
        'egrep "auth required .*/lib/security/pam_u2f.so" /etc/pam.d/login'
    )
    machine.succeed(
        'egrep "auth sufficient .*/lib/security/pam_u2f.so.*cue.*debug.*interactive.*origin=nixos-test.*userpresence=1" /etc/pam.d/sudo'
    )
  '';
}
