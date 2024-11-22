import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "sssd";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ bbigras ];
  };
  nodes.machine = { pkgs, ... }: {
    services.sssd.enable = true;
  };

  testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("sssd.service")
      machine.succeed("sssctl config-check")
    '';
})
