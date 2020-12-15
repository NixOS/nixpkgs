import ./make-test-python.nix ({ pkgs, lib, ...} : let

  customPkgs = pkgs // {
    hello = pkgs.hello.overrideAttrs(old: {
      name = "custom-hello";
    });
  };

in {
  name = "containers-custom-pkgs";
  meta = with lib.maintainers; {
    maintainers = [ adisbladis ];
  };

  machine = { ... }: {
    containers.test = {
      autoStart = true;
      pkgs = customPkgs;
      config = {pkgs, config, ... }: {
        environment.systemPackages = [
          pkgs.hello
        ];
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed(
        "test $(nixos-container run test -- readlink -f /run/current-system/sw/bin/hello) = ${customPkgs.hello}/bin/hello"
    )
  '';
})
