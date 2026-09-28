{
  name = "simple-container";

  containers = {
    machine = { pkgs, ... }: {
      users.users.root.packages = [ pkgs.hello ];
    };
    noprofile = { };
  };

  testScript = ''
    start_all()
    machine.succeed("hello")
    noprofile.fail("hello")
  '';
}
