{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.system.nixos;
in

{

  options.system = {

    nixos.label = mkOption {
      type = types.str;
      description = ''
        NixOS version name to be used in the names of generated
        outputs and boot labels.

        If you ever wanted to influence the labels in your GRUB menu,
        this is the option for you.
      '';
    };

    nixos.tags = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "with-xen" ];
      description = ''
        Strings to prefix to the default
        <option>system.nixos.label</option>.

        Useful for not loosing track of configurations built with
        different options, e.g.:

        <screen>
        {
          system.nixos.tags = [ "with-xen" ];
          virtualisation.xen.enable = true;
        }
        </screen>
      '';
    };

  };

  config = {
    # This is set here rather than up there so that changing it would
    # not rebuild the manual
    system.nixos.label = mkDefault (concatStringsSep "-" (sort (x: y: x < y) cfg.tags) + "-" + cfg.version);
  };

}
