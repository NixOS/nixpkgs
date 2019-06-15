This guide results from the official NixOS manual installation guide. 
I tried to follow exactly the official manual and had to face some issues.
I installed NixOs 19.03 from an bootable USB to Lenovo t420s (previous OS Win10) with UEFI.

1. Created bootable USB stick on different machine with linux (Ubuntu 18.04 OS).
Dont forget to unmount before:
`sudo dd if=name-of-iso.iso of=/dev/sdb`
2. Started installation on Lenovo t420s. `wpa_supplicant.conf` was not available, also the 
option in `/etc/nixos/configuration.nix` to uncomment `networking.wireless.enable = true;` was not
available. So

2.1. connect with `nmcli dev wifi connect "SSID" password "password"`  or

2.2. use ethernet cable and configure the wifi later.
In my case i decided to go with 2.2.

3. Finished installation and reboot, still hanging on ethernet cable.
4. Edited the `/etc/nixos/configuration.nix` like: 

```
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  # Select internationalisation properties.
   i18n = {
   consoleFont = "Lat2-Terminus16";
   consoleKeyMap = "de"; #alternativ "us";
   defaultLocale = "en_US.UTF-8";
   # defaultLocale = "de_DE.UTF-8";
   };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim
    kate
    firefox
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de"; #alternativ "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
```

5. `nixos-rebuild switch`
6. On the way (still dont know why) the following exception occured: 
```
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
    LANGUAGE = (unset),
    LC_ALL = (unset),
    LANG = "en_US.utf8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
```
fixed it with `export LC_ALL=C` and rebooted machine.

7. Realized that in `/etc/nixos/configuration.nix` `networking.wireless.enable = true;` 
and ` networking.networkmanager.enable = true;`
could not coexist. So i uncommented `networking.wireless.enable = true;` and `nixos-rebuild switch` again.
8. Realized that I was not possible to connect to wifi with the GUI elements of kde so i had to
```
systemctl start network-manager
nmcli device wifi rescan
nmcli device wifi connect "SSID" --ask
```
followed by entering the correct password
9. Installed git by typeing `nix-env -iA nixos.pkgs.gitAndTools.gitFull`, created ssh key (`ssh-keygen`).

10. Forked the github nixos repo, set the ssh-key and `git clone https://github.com/nixos/nixpkgs ~/nixpkfs`

11. Now i am ready to start with my fresh NixOS. 
