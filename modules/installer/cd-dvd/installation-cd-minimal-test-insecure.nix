# See installation-cd-minimal.nix
# it's called insecure because it allows logging in as root without password
# So don't boot this cdrom to install your system :-)

{config, pkgs, ...}:

let
  doOverride = pkgs.lib.mkOverride 0 {};
in

{
  require = [ ./installation-cd-minimal.nix ];

  installer.configModule = "./nixos/modules/installer/cd-dvd/installation-cd-minimal-test-insecure";

  services.sshd.permitRootLogin = "yes";
  jobs.sshd = {
    startOn = doOverride "started network-interfaces";
  };


  boot.initrd.extraKernelModules =
    ["cifs" "virtio_net" "virtio_pci" "virtio_blk" "virtio_balloon" "nls_utf8"];

  environment.systemPackages = [ pkgs.vim_configurable ];

  boot.loader.grub.timeout = doOverride 0; 
  boot.loader.grub.default = 2;
  boot.loader.grub.version = doOverride 2;

  # FIXME: rewrite pam.services the to be an attr list
  # I only want to override sshd
  security.pam.services = doOverride
      # Most of these should be moved to specific modules.
      [ { name = "cups"; }
        { name = "ejabberd"; }
        { name = "ftp"; }
        { name = "lshd"; rootOK =true; allowNullPassword =true; }
        { name = "passwd"; }
        { name = "samba"; }
        { name = "sshd"; rootOK = true; allowNullPassword =true; }
        { name = "xlock"; }
        { name = "chsh"; rootOK = true; }
        { name = "su"; rootOK = true; forwardXAuth = true; }
        # Note: useradd, groupadd etc. aren't setuid root, so it
        # doesn't really matter what the PAM config says as long as it
        # lets root in.
        { name = "useradd"; rootOK = true; }
        # Used by groupadd etc.
        { name = "shadow"; rootOK = true; }
        { name = "login"; ownDevices = true; allowNullPassword = true; }
      ];

}

