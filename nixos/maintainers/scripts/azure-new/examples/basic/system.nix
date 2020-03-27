{ pkgs, modulesPath, ... }:

let username = "azurenixosuser";
in
{
  imports = [
    "${modulesPath}/virtualisation/azure-common.nix"
    "${modulesPath}/virtualisation/azure-image.nix"
  ];

  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    description = "Azure NixOS Test User";
    openssh.authorizedKeys.keys = [ (builtins.readFile ~/.ssh/id_ed25519.pub) ];
  };
  nix.trustedUsers = [ username ];

  virtualisation.azureImage.diskSize = 2500;

  system.stateVersion = "20.03";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # test user doesn't have a password
  services.openssh.passwordAuthentication = false;
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git file htop wget curl
  ];
}
