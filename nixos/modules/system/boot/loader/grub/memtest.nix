# This module adds Memtest86+ to the GRUB boot menu.
{ config, lib, pkgs, ... }:

with lib;

let
  memtest86 = pkgs.memtest86plus;
  cfg = config.boot.loader.grub.memtest86;
in

{
  options = {

    boot.loader.grub.memtest86 = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Make Memtest86+, a memory testing program, available from the GRUB
          boot menu.
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

          - `console=...`, set up a serial console.
            Examples:
            `console=ttyS0`,
            `console=ttyS0,9600` or
            `console=ttyS0,115200n8`.

          - `btrace`, enable boot trace.

          - `maxcpus=N`, limit number of CPUs.

          - `onepass`, run one pass and exit if there
            are no errors.

          - `tstlist=...`, list of tests to run.
            Example: `0,1,2`.

          - `cpumask=...`, set a CPU mask, to select CPUs
            to use for testing.

          This list of command line options was obtained by reading the
          Memtest86+ source code.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    boot.loader.grub.extraEntries = ''
      menuentry "Memtest86+" {
        linux @bootRoot@/memtest.bin ${toString cfg.params}
      }
    '';
    boot.loader.grub.extraFiles."memtest.bin" = "${memtest86}/memtest.bin";
  };
}
