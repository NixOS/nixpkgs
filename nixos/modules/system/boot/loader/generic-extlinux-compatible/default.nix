{ config, lib, pkgs, ... }:

with lib;

let
  blCfg = config.boot.loader;
  cfg = blCfg.generic-extlinux-compatible;

  timeoutStr = if blCfg.timeout == null then "-1" else toString blCfg.timeout;

  builder = import ./extlinux-conf-builder.nix { pkgs = pkgs.buildPackages; };
in
{
  options = {
    boot.loader.generic-extlinux-compatible = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to generate an extlinux-compatible configuration file
          under <literal>/boot/extlinux.conf</literal>.  For instance,
          U-Boot's generic distro boot support uses this file format.

          See <link xlink:href="http://git.denx.de/?p=u-boot.git;a=blob;f=doc/README.distro;hb=refs/heads/master">U-boot's documentation</link>
          for more information.
        '';
      };

      configurationLimit = mkOption {
        default = 20;
        example = 10;
        type = types.int;
        description = ''
          Maximum number of configurations in the boot menu.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    system.build.installBootLoader = "${builder} -g ${toString cfg.configurationLimit} -t ${timeoutStr} -c";
    system.boot.loader.id = "generic-extlinux-compatible";
  };
}
