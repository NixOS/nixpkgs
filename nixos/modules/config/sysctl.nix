{ config, pkgs, ... }:

with pkgs.lib;

let

  sysctlOption = mkOptionType {
    name = "sysctl option value";
    check = x: isBool x || isString x || isInt x;
    merge = args: defs: (last defs).value; # FIXME: hacky way to allow overriding in configuration.nix.
  };

in

{

  options = {

    boot.kernel.sysctl = mkOption {
      default = {};
      example = {
        "net.ipv4.tcp_syncookies" = false;
        "vm.swappiness" = 60;
      };
      type = types.attrsOf sysctlOption;
      description = ''
        Runtime parameters of the Linux kernel, as set by
        <citerefentry><refentrytitle>sysctl</refentrytitle>
        <manvolnum>8</manvolnum></citerefentry>.  Note that sysctl
        parameters names must be enclosed in quotes
        (e.g. <literal>"vm.swappiness"</literal> instead of
        <literal>vm.swappiness</literal>).  The value of each parameter
        may be a string, integer or Boolean.
      '';
    };

  };

  config = {

    environment.etc."sysctl.d/nixos.conf".text =
      concatStrings (mapAttrsToList (n: v: "${n}=${if v == false then "0" else toString v}\n") config.boot.kernel.sysctl);

    systemd.services.systemd-sysctl =
      { description = "Apply Kernel Variables";
        before = [ "sysinit.target" "shutdown.target" ];
        wantedBy = [ "sysinit.target" "multi-user.target" ];
        restartTriggers = [ config.environment.etc."sysctl.d/nixos.conf".source ];
        unitConfig.DefaultDependencies = false; # needed to prevent a cycle
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${config.systemd.package}/lib/systemd/systemd-sysctl";
        };
      };

    # Enable hardlink and symlink restrictions.  See
    # https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=800179c9b8a1e796e441674776d11cd4c05d61d7
    # for details.
    boot.kernel.sysctl."fs.protected_hardlinks" = true;
    boot.kernel.sysctl."fs.protected_symlinks" = true;

    # Hide kernel pointers (e.g. in /proc/modules) for unprivileged
    # users as these make it easier to exploit kernel vulnerabilities.
    boot.kernel.sysctl."kernel.kptr_restrict" = 1;

  };

}
