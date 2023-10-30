# nix build -I nixos-config=$PWD/configuration.nix -I nixpkgs=$PWD --file ./nixos vm
{
  config,
  pkgs,
  modulesPath,
  ...
}: {
  guix = {
    enable = true;
    maxJobs = 4;
  };

  users.users.alice = {
    isNormalUser = true;
    extraGroups = ["wheel" "systemd-journal"];
    initialPassword = "alice";
  };

  security.sudo.wheelNeedsPassword = false;

  virtualisation.vmVariant = {
    virtualisation = {
      graphics = false;
      cores = 4;
      memorySize = 4098;
      diskSize = 1024 * 10;
    };
  };

  services.getty.autologinUser = "alice";

  documentation.enable = false;
  system.stateVersion = "23.05";
}
