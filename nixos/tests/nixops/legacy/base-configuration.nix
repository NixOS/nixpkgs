{
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  ssh-keys =
    if builtins.pathExists ../../ssh-keys.nix then # Outside sandbox
      ../../ssh-keys.nix
    # In sandbox
    else
      ./ssh-keys.nix;

  inherit (import ssh-keys pkgs)
    snakeOilPrivateKey
    snakeOilPublicKey
    ;
in
{
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
    (modulesPath + "/testing/test-instrumentation.nix")
  ];
  virtualisation.writableStore = true;
  nix.settings.substituters = lib.mkForce [ ];
  virtualisation.graphics = false;
  documentation.enable = false;
  services.qemuGuest.enable = true;
  boot.loader.grub.enable = false;

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    snakeOilPublicKey
  ];
  security.pam.services.sshd.limits = [
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = 1024;
    }
  ];
}
