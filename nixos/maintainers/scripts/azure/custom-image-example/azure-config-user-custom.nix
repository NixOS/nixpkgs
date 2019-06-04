{ modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/azure-image.nix"
  ];
  config = {
    environment.systemPackages = with pkgs; [
      wget curl openssl tmux neovim
    ];
    services.openssh.permitRootLogin = "no";
    security.sudo.wheelNeedsPassword = false;
  };
}
