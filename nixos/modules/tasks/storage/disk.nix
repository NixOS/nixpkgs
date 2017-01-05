{ pkgs }:

{ name, lib, config, ... }:

let
  inherit (lib) types mkOption;

  matchers = {
    id.desc = "device ID";
    id.devPath = "/dev/disk/by-id";
    id.example = "ata-XY33445566AB_C123DE4F";

    label.desc = "filesystem label";
    label.devPath = "/dev/disk/by-label";
    label.example = "nixos";

    name.desc = "device name";
    name.devPath = "/dev";
    name.example = "sda";

    path.desc = "path";
    path.example = "/srv/disk.img";

    sysfsPath.desc = "sysfs path";
    sysfsPath.example = "/sys/devices/pci0000:00/0000:00:00.0/ata1/host0/"
                      + "target0:0:0/0:0:0:0/block/vda";

    uuid.desc = "device UUID";
    uuid.devPath = "/dev/disk/by-uuid";
    uuid.example = "12345678-90ab-cdef-1234-567890abcdef";
  };

  mkMatcherOption = { desc, devPath ? null, example }: let
    devPathDesc = " (commonly found in <filename>${devPath}/*</filename>)";
    maybeDevPath = lib.optionalString (devPath != null) devPathDesc;
  in mkOption {
    type = types.nullOr types.str;
    default = null;
    inherit example;
    description = "Match based on a ${desc}${maybeDevPath}.";
  };

  matcherOptions.options = {
    physicalPos = mkOption {
      type = types.nullOr (types.addCheck types.int (p: p > 0));
      default = null;
      example = 1;
      description = ''
        Match physical devices based on the position of the kernel's device
        enumeration. Virtual devices such as <literal>/dev/loop0</literal> are
        excluded from this.

        The position is 1-indexed, thus the first device found is position
        <literal>1</literal>.
      '';
    };

    script = mkOption {
      type = types.nullOr types.lines;
      default = null;
      example = ''
        # Match on the first path that includes the disk specification name.
        for i in /dev/*''${disk}*; do echo "$i"; done
        # Match on Nth device found in /dev/sd*, where N is the integer within
        # the disk's specification name.
        ls -1 /dev/sd* | tail -n+''${disk//[^0-9]}
      '';
      apply = script: let
        scriptFile = pkgs.writeScript "match-${name}.sh" ''
          #!${pkgs.bash}/bin/bash -e
          set -o pipefail
          shopt -s nullglob
          export disk="$1" PATH=${lib.escapeShellArg (lib.makeBinPath [
            pkgs.coreutils pkgs.gnused pkgs.utillinux pkgs.bash
          ])}
          ${script}
        '';
      in if script == null then null else scriptFile;
      description = ''
        Match based on the shell script lines set here.

        The script is expected to echo the full path of the matching device to
        stdout. Only the first line is accepted and consecutive lines are
        ignored.

        Within the scripts scope there is a <varname>$disk</varname> variable
        which is the name of the disk specification. For example if the disk to
        be matched is defined as <option>storage.disk.foo.*</option> the
        <varname>$disk</varname> variable would be set to
        <literal>foo</literal>.

        In addition the script is run within bash and has
        <application>coreutils</application>, <application>GNU
        sed</application> and <application>util-linux</application> in
        <envar>PATH</envar>, everything else needs to be explicitly referenced
        using absolute paths.

        Within that shell the <literal>pipefail</literal> and
        <literal>nullglob</literal> options are set in addition to
        <literal>set -e</literal>, so any errors will cause the match to fail.
      '';
    };

    allowIncomplete = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Allow to match an incomplete device, like for example a degraded RAID.
      '';
    };
  } // lib.mapAttrs (lib.const mkMatcherOption) matchers;

in {
  options = {
    clear = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Clear the partition table of this device.
      '';
    };

    initlabel = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Create a new disk label for this device (implies
        <option>clear</option>).
      '';
    };

    match = mkOption {
      type = types.submodule matcherOptions;
      default.name = name;
      description = ''
        Define a way how to match the given device.

        If no <option>match.*</option> options are set,
        <option>match.name</option> is used with the attribute name set as the
        matching value in <option>storage.disk.$name</option>.

        So a definition like <literal>storage.disk.sda = {}</literal> matches
        <literal>/dev/sda</literal>.
      '';
    };
  };

  config = lib.mkIf config.initlabel {
    clear = true;
  };
}
