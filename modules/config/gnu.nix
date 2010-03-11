{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
    gnu = mkOption {
      default = false;
      description =
        '' When enable, GNU software is chosent by default whenever a there is
           a choice between GNU and non-GNU software (e.g., GNU lsh
           vs. OpenSSH).
        '';
    };
  };

  require =
    [ ../installer/grub/grub.nix
      ../services/networking/ssh/sshd.nix
      ../services/networking/ssh/lshd.nix
    ];

  config = mkIf config.gnu {

    environment.systemPackages = with pkgs;
      # TODO: Adjust `requiredPackages' from `system-path.nix'.
      # TODO: Add Inetutils once it has the new `ifconfig'.
      [ grub2 parted fdisk
        nano zile
        texinfo # for the stand-alone Info reader
      ];

    # GNU GRUB.
    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;

    # GNU lsh.
    services.openssh.enable = false;
    services.lshd.enable = true;
    services.xserver.startOpenSSHAgent = false;
    services.xserver.startGnuPGAgent = true;

    # TODO: GNU dico.
    # TODO: GNU Inetutils' inetd.
    # TODO: GNU Pies.
  };
}
