import ./make-test-python.nix {
  name = "nesting";
  nodes =  {
    clone = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.cowsay ];
      nesting.clone = [
        ({ pkgs, ... }: {
          environment.systemPackages = [ pkgs.hello ];
        })
      ];
    };
    children = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.cowsay ];
      nesting.children = [
        ({ pkgs, ... }: {
          environment.systemPackages = [ pkgs.hello ];
        })
      ];
    };
  };
  testScript = ''
    clone.wait_for_unit("default.target")
    clone.succeed("cowsay hey")
    clone.fail("hello")

    with subtest("Nested clones do inherit from parent"):
        clone.succeed(
            "/run/current-system/fine-tune/child-1/bin/switch-to-configuration test"
        )
        clone.succeed("cowsay hey")
        clone.succeed("hello")
    
        children.wait_for_unit("default.target")
        children.succeed("cowsay hey")
        children.fail("hello")

    with subtest("Nested children do not inherit from parent"):
        children.succeed(
            "/run/current-system/fine-tune/child-1/bin/switch-to-configuration test"
        )
        children.fail("cowsay hey")
        children.succeed("hello")
  '';
}
