{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    gnu = mkOption {
      type = types.bool;
      default = false;
      description =
        '' When enabled, GNU software is chosen by default whenever a there is
           a choice between GNU and non-GNU software.
        '';
    };
  };

  config = mkIf config.gnu {

    environment.systemPackages = with pkgs;
      # TODO: Adjust `requiredPackages' from `system-path.nix'.
      # TODO: Add Inetutils once it has the new `ifconfig'.
      [ parted
        #fdisk  # XXX: GNU fdisk currently fails to build and it's redundant
                # with the `parted' command.
        nano zile
        texinfo # for the stand-alone Info reader
      ]
      ++ stdenv.lib.optional (!stdenv.isArm) grub2;


    # GNU GRUB, where available.
    boot.loader.grub.enable = !pkgs.stdenv.isArm;
    boot.loader.grub.version = 2;

    # TODO: GNU dico.
    # TODO: GNU Inetutils' inetd.
    # TODO: GNU Pies.
  };
}
