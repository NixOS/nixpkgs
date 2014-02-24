# This module adds Memtest86+ to the GRUB boot menu.

{ config, pkgs, ... }:

with pkgs.lib;

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

          <itemizedlist>

          <listitem>
            <para><literal>console=...</literal>, set up a serial console.
            Examples:
            <literal>console=ttyS0</literal>,
            <literal>console=ttyS0,9600</literal> or
            <literal>console=ttyS0,115200n8</literal>.</para>
          </listitem>

          <listitem>
            <para><literal>btrace</literal>, enable boot trace.</para>
          </listitem>

          <listitem>
            <para><literal>maxcpus=N</literal>, limit number of CPUs.</para>
          </listitem>

          <listitem>
            <para><literal>onepass</literal>, run one pass and exit if there
            are no errors.</para>
          </listitem>

          <listitem>
            <para><literal>tstlist=...</literal>, list of tests to run.
            Example: <literal>0,1,2</literal>.</para>
          </listitem>

          <listitem>
            <para><literal>cpumask=...</literal>, set a CPU mask, to select CPUs
            to use for testing.</para>
          </listitem>

          </itemizedlist>

          This list of command line options was obtained by reading the
          Memtest86+ source code.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    boot.loader.grub.extraEntries =
      if config.boot.loader.grub.version == 2 then
        ''
          menuentry "Memtest86+" {
            linux16 @bootRoot@/memtest.bin ${toString cfg.params}
          }
        ''
      else
        throw "Memtest86+ is not supported with GRUB 1.";

    boot.loader.grub.extraFiles."memtest.bin" = "${memtest86}/memtest.bin";

  };
}
