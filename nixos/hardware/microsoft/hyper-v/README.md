This is a setup for installing NixOS in Hyper-V as a guest.

I don't have details handy anymore on the detailed steps I had to do on the Windows host
(there's no NixWindows yet, unfortunately...), so you'll have to try googling that yourself, e.g. something like
"linux on hyper-v" or "ubuntu on hyper-v". (You're welcome to send PRs with improvements of this guide.)
Below, I'm providing only the info with what to do on the NixOS side of things.

## Installation ##

I basically followed the [guide for NixOS on VirtualBox](https://nixos.org/wiki/Installing_NixOS_in_a_VirtualBox_guest).
However, some additional changes in `/etc/nixos/configuration.nix` were required to really make it work
(I don't include them as a .nix file, as they must be done **before `nixos-install`**, and I'm not sure how to proceed
with cloning the nixos-hardware repo at this stage):

    # REQUIRED - see: https://github.com/nixos/nixpkgs/issues/9899
    boot.initrd.kernelModules = ["hv_vmbus" "hv_storvsc"];

    # RECOMMENDED
    # - use 800x600 resolution for text console, to make it easy to fit on screen
    boot.kernelParams = ["video=hyperv_fb:800x600"];  # https://askubuntu.com/a/399960
    # - avoid a problem with `nix-env -i` running out of memory
    boot.kernel.sysctl."vm.overcommit_memory" = "1"; # https://github.com/NixOS/nix/issues/421

    # UNKNOWN - not sure if below are needed; were suggested for VirtualBox and I used them
    boot.loader.grub.device = "/dev/sda";
    boot.initrd.checkJournalingFS = false;

## Shared folder ##

To share a folder between Windows host and Linux/NixOS guest, the typical solution seems to be to make a folder "shared"
on Windows, then access it via Samba from NixOS.
On the Windows host, I had to make an additional virtual switch in Hyper-V Manager, with mode "internal".
Then in properties of the virtual network card on Windows host (attached to the virtual switch), I
changed the IP to a fixed 10.0.0.100 (mask 255.255.255.240). I also added a special purpose user on the host, with some
long randomly generated password, to act as Samba credentials for NixOS.
To test that it works, I used the following commands:

    $ nix-env -iA nixos.samba
    $ smbclient -L //10.0.0.100 -U shares-guest%ReplaceWithSomeLongRandomlyGeneratedPassword
    Domain=[DESKTOP-ABCD123] OS=[Windows 10 Pro 14393] Server=[Windows 10 Pro 6.3]
    
    	Sharename       Type      Comment
    	---------       ----      -------
    	ADMIN$          Disk      Administracja zdalna
    	C$              Disk      Domyślny udział
    	IPC$            IPC       Zdalne wywołanie IPC 
    	shared-space    Disk      
    Connection to 10.0.0.100 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
    NetBIOS over TCP disabled -- no workgroup available

    $ nix-env -e samba

Then I added the following lines in `/etc/nixos/configuration.nix`:

    # Client for shared folder on Windows Hyper-V host
    # Based on: nixpkgs.git/nixos/tests/samba.nix
    fileSystems."/vm-share" = {
      fsType = "cifs";
      device = "//10.0.0.100/shared-space";
      options = [ "username=shares-guest" "password=ReplaceWithSomeLongRandomlyGeneratedPassword" ];
    };
    networking.interfaces.eth1.ip4 = [{address="10.0.0.101"; prefixLength=28;}];

