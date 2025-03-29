{
  network = {
    description = "Legacy Network using <nixpkgs> and legacy state.";
    # NB this is not really what makes it a legacy network; lack of flakes is.
    storage.legacy = { };
  };
  server =
    { lib, pkgs, ... }:
    {
      deployment.targetEnv = "none";
      imports = [
        ./base-configuration.nix
        (lib.modules.importJSON ./server-network.json)
      ];
      environment.systemPackages = [
        pkgs.hello
        pkgs.figlet
      ];
    };
}
