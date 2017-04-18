import ./make-test.nix ({ pkgs, latestKernel ? false, ... }:

{
  name = "pam-u2f";

  machine =
    { config, pkgs, lib, ... }:
    {
      security.pam.u2f = {
        enable = true;
        interactive=true;
        control="sufficient";
        cue=true;
        debug=true;
      };
    };

  testScript =
    ''
      $machine->waitForUnit('multi-user.target');
      $machine->succeed('egrep "auth sufficient .*u2f.*" /etc/pam.d/ -R ');

    '';

})
