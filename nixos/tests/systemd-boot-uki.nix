{
  signed ? false,
  xbootldr ? false,
}:
{ pkgs, lib, ... }:
let
  extraArchive = pkgs.runCommand "uki-extra-initrd.cpio" { nativeBuildInputs = [ pkgs.cpio ]; } ''
    printf disposable-extra-archive > uki-extra-canary
    find . -print0 | cpio --null -o --format=newc > $out
  '';
  common = {
    # The XBOOTLDR machine uses the explicit disk image below; candidate nodes
    # supply closures only and must not request QEMU's default system image.
    virtualisation.useBootLoader = if xbootldr then lib.mkForce false else true;
    virtualisation.directBoot.enable = lib.mkIf xbootldr false;
    boot.loader.supportsInitrdSecrets = lib.mkIf xbootldr (lib.mkOverride 0 true);
    virtualisation.useEFIBoot = true;
    virtualisation.memorySize = 2048;
    virtualisation.diskSize = 4096;
    # Every candidate closure must retain the custom disk's partition layout.
    virtualisation.useDefaultFilesystems = lib.mkIf xbootldr false;
    virtualisation.bootPartition = lib.mkIf xbootldr null;
    virtualisation.fileSystems = lib.mkIf xbootldr {
      "/" = {
        device = "/dev/vda3";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/vda2";
        fsType = "vfat";
        noCheck = true;
      };
      "/efi" = {
        device = "/dev/vda1";
        fsType = "vfat";
        noCheck = true;
      };
    };
    boot.loader.systemd-boot = {
      enable = true;
      uki.enable = true;
      bootCounting.enable = true;
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = if xbootldr then "/efi" else "/boot";
    boot.loader.systemd-boot.xbootldrMountPoint = lib.mkIf xbootldr "/boot";
    system.boot.extraInitrd.paths = lib.optionals xbootldr [ "extra-uki.cpio" ];
    boot.loader.systemd-boot.extraPrepareCommands = lib.mkIf xbootldr ''
      cp ${extraArchive} /boot/extra-uki.cpio
    '';
    boot.initrd.systemd.mounts = lib.optionals xbootldr [
      {
        what = "/uki-extra-canary";
        where = "/sysroot/run/uki-extra-canary";
        type = "none";
        options = "bind";
        unitConfig.DefaultDependencies = false;
        requiredBy = [ "initrd-fs.target" ];
        before = [ "initrd-fs.target" ];
      }
    ];
    boot.initrd.systemd.enable = true;
    system.switch.enable = true;
    nix.enable = true;
    environment.etc."machine-id".text = "1234567890abcdef1234567890abcdef\n";
  };
  candidate = marker: {
    imports = [ common ];
    # These nodes supply closures; only the bootstrap machine is started.
    virtualisation.installBootLoader = false;
    boot.kernelParams = [ "uki.test=${marker}" ];
    boot.loader.systemd-boot.uki = lib.mkIf signed {
      privateKey = "/var/lib/sbctl/keys/db/db.key";
      certificate = "/var/lib/sbctl/keys/db/db.pem";
    };
    boot.initrd.secrets."/run/uki-test-secret" = "/root/uki-secret-${marker}";
    specialisation.recovery.configuration.boot.kernelParams = [ "uki.specialisation=1" ];
  };
in
{
  name =
    "systemd-boot-uki"
    + lib.optionalString signed "-secure-boot"
    + lib.optionalString xbootldr "-xbootldr";
  meta.maintainers = with lib.maintainers; [ julienmalka ];
  nodes = {
    machine = { nodes, config, ... }: {
      imports = [ common ];
      # Exercise migration from legacy systemd-boot entries on first install.
      boot.loader.systemd-boot.uki.enable = lib.mkForce false;
      # Model an older bootspec without the new uname extension.
      boot.bootspec.extensions."org.nixos.systemd-boot".uname = lib.mkForce null;
      boot.initrd.secrets."/run/uki-legacy-secret" = "/root/uki-secret-legacy";
      boot.loader.systemd-boot.extraPrepareCommands = ''
        printf 'disposable-legacy-fixture\n' > /root/uki-secret-legacy
      '';
      # UKIs duplicate the initrd for each generation and specialisation.
      virtualisation.useBootLoader = lib.mkForce false;
      # The custom disk image below installs systemd-boot; suppress the
      # direct-kernel QEMU module's assumption that secrets are unsupported.
      boot.loader.supportsInitrdSecrets = lib.mkOverride 0 true;
      virtualisation.directBoot.enable = false;
      virtualisation.useDefaultFilesystems = false;
      virtualisation.bootPartition = null;
      virtualisation.fileSystems = {
        "/" = {
          device = if xbootldr then "/dev/vda3" else "/dev/vda2";
          fsType = "ext4";
        };
        "/boot" = {
          device = if xbootldr then "/dev/vda2" else "/dev/vda1";
          fsType = "vfat";
          noCheck = true;
        };
      }
      // lib.optionalAttrs xbootldr {
        "/efi" = {
          device = "/dev/vda1";
          fsType = "vfat";
          noCheck = true;
        };
      };
      system.build.diskImage = import ../lib/make-disk-image.nix {
        inherit config pkgs lib;
        label = "nixos";
        format = "qcow2";
        partitionTableType = if xbootldr then "efixbootldr" else "efi";
        bootSize = "1024M";
        touchEFIVars = true;
        installBootLoader = true;
        copyChannel = false;
      };
      virtualisation.efi.variables = "${config.system.build.diskImage}/efi-vars.fd";
      environment.systemPackages = [
        pkgs.sbctl
        pkgs.sbsigntool
        pkgs.openssl
        pkgs.binutils
        pkgs.python3
      ];
      system.extraDependencies = [
        nodes.first.system.build.toplevel
        nodes.second.system.build.toplevel
      ];
    };
    first = candidate "first";
    second = candidate "second";
  };
  testScript = { nodes, ... }: ''
    import os
    import shlex
    import subprocess
    import tempfile

    disk = tempfile.NamedTemporaryFile()
    subprocess.run([
        "${nodes.machine.virtualisation.qemu.package}/bin/qemu-img", "create",
        "-f", "qcow2", "-F", "qcow2", "-b",
        "${nodes.machine.system.build.diskImage}/nixos.qcow2", disk.name,
    ], check=True)
    os.environ["NIX_DISK_IMAGE"] = disk.name

    first = "${nodes.first.system.build.toplevel}"
    second = "${nodes.second.system.build.toplevel}"
    recovery = "${nodes.first.specialisation.recovery.configuration.system.build.toplevel}"
    certificate = "/var/lib/sbctl/keys/db/db.pem"
    esp = "${if xbootldr then "/efi" else "/boot"}"

    def check_boot(system_path, marker, generation, specialisation=False):
        machine.wait_for_unit("multi-user.target")
        machine.succeed(f'test "$(readlink -f /run/current-system)" = "{system_path}"')
        machine.succeed(f"grep -F '{marker}' /proc/cmdline")
        machine.succeed("bootctl status | grep -F systemd-stub")
        ${lib.optionalString signed ''
          machine.succeed("bootctl status | grep -F 'Secure Boot: enabled (user)'")
        ''}
        machine.succeed("grep -Fx disposable-uki-fixture /run/uki-test-secret")
        ${lib.optionalString xbootldr ''
          machine.succeed("grep -Fx disposable-extra-archive /run/uki-extra-canary")
              machine.fail("test -e /efi/extra-uki.cpio")
        ''}
        title = "NixOS (recovery)" if specialisation else "NixOS"
        # A previously blessed rollback entry does not pull in boot-complete.target.
        machine.wait_until_succeeds(
            f"entry=$(grep -l 'version Generation {generation} ' /boot/loader/entries/nixos-*.conf | "
            f"xargs grep -lFx 'title {title}'); test -n \"$entry\"; "
            "case $entry in *+*) exit 1;; esac"
        )

    def image_for(generation):
        entry = machine.succeed(
            f"grep -l 'version Generation {generation} ' /boot/loader/entries/nixos-*.conf | "
            "xargs grep -l '^title NixOS$'"
        ).strip()
        return "/boot" + machine.succeed(f"sed -n 's/^uki //p' {shlex.quote(entry)}").strip()

    def snapshot():
        return machine.succeed(f"find /boot {esp} -type f -exec sha256sum {{}} + | sort -u")

    def install(system_path):
        machine.succeed(f"nix-env -p /nix/var/nix/profiles/system --set {system_path}")
        machine.succeed(f"{system_path}/bin/switch-to-configuration boot")

    machine.start(allow_reboot=True)
    machine.wait_for_unit("multi-user.target")
    machine.fail("bootctl status | grep -F systemd-stub")
    machine.succeed("grep -Fx disposable-legacy-fixture /run/uki-legacy-secret")
    ${lib.optionalString (!signed) ''machine.succeed("rm /root/uki-secret-legacy")''}
    machine.succeed("printf 'disposable-uki-fixture\\n' | tee /root/uki-secret-first /root/uki-secret-second")
    machine.succeed("mkdir -p /boot/EFI/other; printf preserved > /boot/EFI/other/keep.efi")

    ${lib.optionalString signed ''
      with subtest("Missing signing key leaves every existing boot file unchanged"):
          machine.succeed(f"nix-env -p /nix/var/nix/profiles/system --set {first}")
          before = snapshot()
          machine.fail(f"{first}/bin/switch-to-configuration boot")
          assert snapshot() == before

      # All enrollment and signing happen exclusively in this disposable guest.
      machine.succeed("sbctl create-keys")
      machine.succeed(f"sbctl sign {esp}/EFI/systemd/systemd-bootx64.efi")
      machine.succeed(f"sbctl sign {esp}/EFI/BOOT/BOOTX64.EFI")
      machine.succeed("sbctl enroll-keys --yes-this-might-brick-my-machine")

      with subtest("A readable signing key is refused before publication"):
          machine.succeed("chmod 0644 /var/lib/sbctl/keys/db/db.key")
          before = snapshot()
          machine.fail(f"{first}/bin/switch-to-configuration boot")
          assert snapshot() == before
          machine.succeed("chmod 0600 /var/lib/sbctl/keys/db/db.key")

      with subtest("A replaceable public certificate is refused before publication"):
          machine.succeed(f"chmod 0666 {certificate}")
          before = snapshot()
          error = machine.fail(f"{first}/bin/switch-to-configuration boot 2>&1")
          assert "UKI certificate" in error and "Traceback" not in error, error
          assert snapshot() == before
          machine.succeed(f"chmod 0644 {certificate}")

      with subtest("Mismatched certificate fails before ESP publication"):
          machine.succeed(f"cp {certificate} /root/original.pem")
          machine.succeed(
              f"openssl req -new -x509 -newkey rsa:2048 -noenc -days 1 "
              f"-subj /CN=DisposableWrongKey/ -keyout /root/wrong.key -out {certificate}"
          )
          before = snapshot()
          machine.fail(f"{first}/bin/switch-to-configuration boot")
          assert snapshot() == before
          machine.succeed(f"cp /root/original.pem {certificate}")

      with subtest("Signed migration never promotes an unauthenticated legacy initrd tail"):
          machine.succeed("rm /root/uki-secret-legacy")
          machine.succeed("entry=$(grep -l 'version Generation 1 ' /boot/loader/entries/nixos-*.conf); initrd=$(sed -n 's/^initrd //p' $entry | head -1); printf untrusted-legacy-tail >> /boot$initrd")
          install(first)
          legacy_image = image_for(1)
          machine.succeed(f"objcopy --dump-section .initrd=/root/legacy-initrd {legacy_image} /root/inspected.efi")
          machine.fail("grep -aF untrusted-legacy-tail /root/legacy-initrd")
          machine.fail("grep -aF disposable-legacy-fixture /root/legacy-initrd")
          machine.succeed("printf 'disposable-legacy-fixture\\n' > /root/uki-secret-legacy")
      ${lib.optionalString xbootldr ''
        # Signed mode must create ESP/loader itself, before publication.
        machine.succeed("rm -rf /efi/loader")
      ''}
    ''}

    with subtest("Install and actually boot the first UKI generation"):
        install(first)
        first_image = image_for(2)
        machine.succeed(f"objcopy --dump-section .cmdline=/root/cmdline {shlex.quote(first_image)} /root/inspected.efi")
        machine.succeed(f"grep -F 'init={first}/init' /root/cmdline")
        ${lib.optionalString signed ''
          machine.succeed(f"sbverify --cert {certificate} {shlex.quote(first_image)}")
        ''}
        machine.reboot()
        check_boot(first, "uki.test=first", 2)

    ${lib.optionalString signed ''machine.succeed("rm /root/uki-secret-legacy")''}

    with subtest("Migration retains a legacy initrd whose runtime secret is retired"):
        entry = machine.succeed(
            "grep -l 'version Generation 1 ' /boot/loader/entries/nixos-*.conf"
        ).strip()
        entry_id = os.path.basename(entry).split("+")[0].removesuffix(".conf") + ".conf"
        machine.succeed(f"bootctl set-oneshot {shlex.quote(entry_id)}")
        machine.reboot()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("bootctl status | grep -F systemd-stub")
        machine.succeed("grep -Fx disposable-legacy-fixture /run/uki-legacy-secret")
        machine.fail("test -e /root/uki-secret-legacy")
        machine.reboot()
        check_boot(first, "uki.test=first", 2)

    with subtest("Actually boot the forward UKI generation"):
        # An older generation's appender now fails, including its specialisation.
        machine.succeed("rm /root/uki-secret-first")
        first_hash = machine.succeed(f"sha256sum {shlex.quote(first_image)}")
        with subtest("Insufficient temporary space is actionable and leaves boot files unchanged"):
            machine.succeed("mkdir -p /root/uki-small-tmp; mount -t tmpfs -o size=4M tmpfs /root/uki-small-tmp")
            before = snapshot()
            error = machine.fail(f"TMPDIR=/root/uki-small-tmp {first}/bin/switch-to-configuration boot 2>&1")
            assert "TMPDIR" in error and "Traceback" not in error, error
            assert snapshot() == before
            machine.succeed("umount /root/uki-small-tmp")
        with subtest("Insufficient space fails before publication"):
            machine.succeed(f"nix-env -p /nix/var/nix/profiles/system --set {second}")
            machine.succeed(
                "free=$(df --output=avail -B1 /boot | tail -1); "
                "fallocate -l $((free - 4 * 1024 * 1024)) /boot/space-fixture"
            )
            before = snapshot()
            machine.fail(f"{second}/bin/switch-to-configuration boot")
            assert snapshot() == before
            machine.succeed("rm /boot/space-fixture")
        install(second)
        assert machine.succeed(f"sha256sum {shlex.quote(first_image)}") == first_hash
        second_image = image_for(3)
        assert second_image != first_image
        machine.reboot()
        check_boot(second, "uki.test=second", 3)

    with subtest("Reinstall preserves a blessed entry and image identity"):
        before = snapshot()
        machine.succeed(f"{second}/bin/switch-to-configuration boot")
        assert snapshot() == before

    with subtest("Missing secrets for the requested default remain fatal"):
        machine.succeed("mv /root/uki-secret-second /root/saved-secret")
        before = snapshot()
        machine.fail(f"{second}/bin/switch-to-configuration boot")
        assert snapshot() == before
        machine.succeed("mv /root/saved-secret /root/uki-secret-second")

    with subtest("Retained UKIs still require intact executable contents"):
        machine.succeed(f"cp {shlex.quote(first_image)} /root/retained.efi")
        machine.succeed(f"printf X | dd of={shlex.quote(first_image)} bs=1 seek=512 count=1 conv=notrunc")
        before = snapshot()
        machine.fail(f"{second}/bin/switch-to-configuration boot")
        assert snapshot() == before
        machine.succeed(f"cp /root/retained.efi {shlex.quote(first_image)}")

    with subtest("A corrupted existing UKI is refused before menu/default changes"):
        machine.succeed(f"cp {shlex.quote(second_image)} /root/original.efi")
        machine.succeed(f"printf X | dd of={shlex.quote(second_image)} bs=1 seek=512 count=1 conv=notrunc")
        before = snapshot()
        machine.fail(f"{second}/bin/switch-to-configuration boot")
        assert snapshot() == before
        machine.succeed(f"cp /root/original.efi {shlex.quote(second_image)}")

    with subtest("Malformed optional headers and duplicate zero-sized sections are refused"):
        machine.succeed(f"cp {shlex.quote(second_image)} /root/pe-original.efi")
        for mutation in ("short_header", "missing_directory", "duplicate_empty_section"):
            script = (
                "import struct; "
                f"p={second_image!r}; f=open(p,'r+b'); h=f.read(4096); "
                "pe=struct.unpack_from('<I',h,60)[0]; opt=pe+24; "
            )
            if mutation == "short_header":
                script += "f.seek(pe+20); f.write(struct.pack('<H',20))"
            elif mutation == "missing_directory":
                script += "f.seek(opt+108); f.write(struct.pack('<I',4))"
            else:
                script += "table=opt+struct.unpack_from('<H',h,pe+20)[0]; f.seek(table); f.write(b'.cmdline'); f.seek(table+16); f.write(struct.pack('<I',0))"
            machine.succeed("${pkgs.python3}/bin/python3 -c " + shlex.quote(script))
            before = snapshot()
            machine.fail(f"{second}/bin/switch-to-configuration boot")
            assert snapshot() == before
            machine.succeed(f"cp /root/pe-original.efi {shlex.quote(second_image)}")

    ${lib.optionalString signed ''
      with subtest("A trusted but different manager is refused before publication"):
          manager = f"{esp}/EFI/systemd/systemd-bootx64.efi"
          machine.succeed(f"cp {manager} /root/original-manager.efi")
          machine.succeed("cp ${nodes.first.systemd.package}/lib/systemd/boot/efi/systemd-bootx64.efi /root/stale-manager.efi")
          machine.succeed(r"sed -i 's/#### LoaderInfo: systemd-boot [0-9]/#### LoaderInfo: systemd-boot 0/' /root/stale-manager.efi")
          machine.succeed(f"${pkgs.sbsigntool}/bin/sbsign --key /var/lib/sbctl/keys/db/db.key --cert {certificate} --output {manager} /root/stale-manager.efi")
          machine.succeed(f"${pkgs.sbsigntool}/bin/sbverify --cert {certificate} {manager}")
          before = snapshot()
          error = machine.fail(f"{second}/bin/switch-to-configuration boot 2>&1")
          assert manager in error and "${nodes.first.systemd.package}" in error, error
          assert snapshot() == before
          machine.succeed(f"cp /root/original-manager.efi {manager}")
    ''}

    with subtest("Actually boot rollback, then its specialisation"):
        before = snapshot()
        machine.fail(f"{recovery}/bin/switch-to-configuration boot")
        assert snapshot() == before
        machine.succeed("printf 'disposable-uki-fixture\\n' > /root/uki-secret-first")
        machine.succeed("nix-env -p /nix/var/nix/profiles/system --rollback")
        machine.succeed(f"{first}/bin/switch-to-configuration boot")
        machine.reboot()
        check_boot(first, "uki.test=first", 2)
        machine.succeed(f"{recovery}/bin/switch-to-configuration boot")
        machine.reboot()
        check_boot(recovery, "uki.specialisation=1", 2, specialisation=True)

    with subtest("Pruning removes only unreferenced NixOS boot files"):
        machine.succeed("nix-env -p /nix/var/nix/profiles/system --delete-generations 3")
        machine.succeed(f"{recovery}/bin/switch-to-configuration boot")
        machine.fail(f"test -e {shlex.quote(second_image)}")
        machine.succeed("grep -Fx preserved /boot/EFI/other/keep.efi")
        machine.reboot()
        check_boot(recovery, "uki.specialisation=1", 2, specialisation=True)
  '';
}
