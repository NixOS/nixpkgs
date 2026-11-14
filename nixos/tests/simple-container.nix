{
  name = "simple-container";

  containers = {
    machine = { pkgs, ... }: {
      environment.defaultPackages = [
        # Temporary workaround for #263295/#263289
      ];
      users.users.root.packages = [ pkgs.hello ];
    };
    noprofile = {
      environment.defaultPackages = [
        # Temporary workaround for #263295/#263289
      ];
    };
  };

  testScript = ''
    start_all()
    machine.succeed("hello")
    noprofile.fail("hello")
  '';
}
