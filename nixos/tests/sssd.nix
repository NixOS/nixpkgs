import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "sssd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bbigras ];
  };
  machine = { pkgs, ... }: {
    services.sssd.enable = true;
  };

  testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("sssd.service")
    '';
})
