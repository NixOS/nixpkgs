import ./make-test-python.nix ({ pkgs, ... }: {
  name = "ergo";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mmahut ];
  };

  nodes = {
    machine = { ... }: {
      services.ergo.enable = true;
      services.ergo.api.keyHash = "324dcf027dd4a30a932c441f365a25e86b173defa4b8e58948253471b81b72cf";
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("ergo.service")
  '';
})
