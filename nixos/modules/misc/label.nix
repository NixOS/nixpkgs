{ config, lib, ... }:

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

        The default is <option>system.nixos.tags</option> separated by
        "-" + "-" + <envar>NIXOS_LABEL_VERSION</envar> environment
        variable (defaults to the value of
        <option>system.nixos.version</option>).

        Can be overriden by setting <envar>NIXOS_LABEL</envar>.

        Useful for not loosing track of configurations built from different
        nixos branches/revisions, e.g.:

        <screen>
        #!/bin/sh
        today=`date +%Y%m%d`
        branch=`(cd nixpkgs ; git branch 2>/dev/null | sed -n '/^\* / { s|^\* ||; p; }')`
        revision=`(cd nixpkgs ; git rev-parse HEAD)`
        export NIXOS_LABEL_VERSION="$today.$branch-''${revision:0:7}"
        nixos-rebuild switch</screen>
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
    system.nixos.label = mkDefault (maybeEnv "NIXOS_LABEL"
                                             (concatStringsSep "-" ((sort (x: y: x < y) cfg.tags)
                                              ++ [ (maybeEnv "NIXOS_LABEL_VERSION" cfg.version) ])));
  };

}
