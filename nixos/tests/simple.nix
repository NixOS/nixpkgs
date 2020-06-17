import ./make-test-python.nix ({ pkgs, ...} : {
  name = "simple";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.shutdown()
    '';
})
