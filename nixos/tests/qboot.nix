import ./make-test-python.nix ({ pkgs, ...} : {
  name = "qboot";

  nodes.machine = { ... }: {
    virtualisation.bios = pkgs.qboot;
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")
    '';
})
