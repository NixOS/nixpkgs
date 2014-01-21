# This module adds Memtest86+ to the GRUB boot menu.

{ config, pkgs, ... }:

with pkgs.lib;

let
  memtest86 = pkgs.memtest86plus;
  cfg = config.boot.loader.grub.memtest86;
  params = concatStringsSep " " cfg.params;
in

{
  options = {

    boot.loader.grub.memtest86 = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Make Memtest86+, a memory testing program, available from the
          GRUB boot menu.
        '';
      };

      params = mkOption {
        default = [];
        example = [ "console=ttyS0,115200" ];
        type = types.listOf types.str;
        description = ''
          Parameters added to the Memtest86+ command line. As of memtest86+ 5.01
          the following list of (apparently undocumented) parameters are
          accepted:
            console=... -- set up a serial console.
            btrace      -- enable boot trace.
            maxcpus=... -- limit number of CPUs.
            onepass     -- run one pass and exit if there are no errors.
            tstlist=... -- list of tests to run.
            cpumask=... -- set a CPU mask, to select CPUs to use for testing.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    boot.loader.grub.extraEntries =
      if config.boot.loader.grub.version == 2 then
        ''
          menuentry "Memtest86+" {
            linux16 @bootRoot@/memtest.bin ${params}
          }
        ''
      else
        throw "Memtest86+ is not supported with GRUB 1.";

    boot.loader.grub.extraFiles."memtest.bin" = "${memtest86}/memtest.bin";

  };
}
