{ lib, ... }: {
  imports = [ ./containers-imperative.nix ];
  name = lib.mkForce "containers-imperative-no-daemon";
  test-nix-in-container = false;
  nodes.machine =
    { config, ... }:
    {
      nix.daemon.enable = false;
      assertions = [
        # no mkForce trickery
        {
          assertion = !config.nix.daemon.enable;
          message = "test failed: nix.daemon.enable has override";
        }
      ];
    };
}
