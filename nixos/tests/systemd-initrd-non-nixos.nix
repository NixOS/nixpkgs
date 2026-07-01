{ lib, pkgs, ... }:
let
  marker = "REACHED NON-NIXOS INIT AS PID 1";

  # A non-NixOS init (no prepare-root). We use a store path, not literal
  # /bin/sh: a fresh disk has no /bin/sh yet (it is created by the activation a
  # non-NixOS init skips), while the store is always mounted; init=/bin/sh works
  # the same on a real system. Writes a marker, then stays alive so PID 1 lives.
  nonNixosInit = pkgs.writeShellScriptBin "non-nixos" ''
    echo "${marker}" > /dev/console
    exec ${pkgs.coreutils}/bin/sleep infinity
  '';

  common = {
    boot.initrd.systemd.enable = true;

    virtualisation = {
      # tmpfs root, like real non-NixOS closure init= microvm consumers.
      diskImage = null;

      graphics = false;
    };

    # Speed up wait_for_console.
    boot.consoleLogLevel = lib.mkForce 3;
    boot.initrd.systemd.managerEnvironment.SYSTEMD_LOG_LEVEL = "warning";

    # switch-root needs an os-release on the target root. A real system has one
    # on disk; our fresh tmpfs does not, so create it.
    boot.initrd.systemd.tmpfiles.settings."10-os-release"."/sysroot/etc/os-release".f = {
      mode = "0644";
      argument = "ID=test-non-nixos";
    };
  };
in
{
  name = "systemd-initrd-non-nixos";

  nodes = {
    bashActivation = common;

    nixosInit = {
      imports = [ common ];
      system.nixos-init.enable = true;
      system.etc.overlay.enable = true;
      services.userborn.enable = true;
    };
  };

  testScript = ''
    import os

    # The last init= on the cmdline wins; QEMU_KERNEL_PARAMS is appended after
    # the default one, so this boots our non-NixOS init.
    os.environ["QEMU_KERNEL_PARAMS"] = "init=${lib.getExe nonNixosInit}"

    start_all()

    # If a code path does not skip the non-NixOS init, switch-root is blocked and
    # the machine drops to emergency mode: the marker never appears and the wait
    # times out.
    with subtest("bash initrd-nixos-activation skips a non-NixOS init"):
        bashActivation.wait_for_console_text("${marker}", timeout=300)

    with subtest("nixos-init switches to a non-NixOS init directly"):
        nixosInit.wait_for_console_text("${marker}", timeout=300)
  '';
}
