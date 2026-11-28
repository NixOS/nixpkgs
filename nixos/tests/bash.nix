{
  name = "bash";

  nodes.machine =
    { lib, ... }:

    {
      programs.bash = {
        enable = true;
        logout = lib.mkAfter "echo do-you-see-me";
      };

      # Avoid slow man cache build
      documentation.man.enable = false;
    };

  testScript =
    #python
    ''
      start_all()
      output = machine.succeed("echo 'echo' | bash --login -u -i")
      t.assertIn("do-you-see-me", output)
      t.assertNotIn("unbound variable", output)
    '';
}
