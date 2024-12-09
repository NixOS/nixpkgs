import ./make-test-python.nix ({ pkgs, lib, ... }: let

  customPkgs = pkgs.appendOverlays [ (self: super: {
    hello = super.hello.overrideAttrs (old: {
       name = "custom-hello";
    });
  }) ];

in {
  name = "containers-custom-pkgs";
  meta = {
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };

  nodes.machine = { config, ... }: {
    assertions = let
      helloName = (builtins.head config.containers.test.config.system.extraDependencies).name;
    in [ {
      assertion = helloName == "custom-hello";
      message = "Unexpected value: ${helloName}";
    } ];

    containers.test = {
      autoStart = true;
      config = { pkgs, config, ... }: {
        nixpkgs.pkgs = customPkgs;
        system.extraDependencies = [ pkgs.hello ];
      };
    };
  };

  # This test only consists of evaluating the test machine
  testScript = "pass";
})
