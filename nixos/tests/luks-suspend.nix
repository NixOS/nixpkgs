# Tests that `cryptsetup luksSuspend` successfully wipes the volume key from memory.
{ pkgs, lib, ... }:

let
  # Fixed 64-byte volume key.
  # Chosen by fair dice roll. Guaranteed to be random. :-)
  # (tr -dc '0-9A-Za-z' </dev/urandom | head -c 64)
  volumeKey = "Okqf1piY8oebIL11l3x5lkqzyqLuY8X0aROgI6wMuUV99PoeqHbgsptcACs0ojaL";
  luksUUID = "55555555-5555-5555-5555-555555555555";

  # 1 GiB of RAM for the VM. Less than the 4 GiB PCI hole, so that a
  # single `pmemsave 0 <MEM_BYTES>` captures all of guest RAM.
  memorySizeMiB = 1024;

  # A LUKS2 container with the known master key above.
  luksImage =
    pkgs.runCommand "luks-suspend-test-disk.img" { nativeBuildInputs = [ pkgs.cryptsetup ]; }
      ''
        truncate -s 64M $out

        echo -n abc | cryptsetup luksFormat \
          --batch-mode \
          --uuid ${luksUUID} \
          --pbkdf pbkdf2 --pbkdf-force-iterations 1000 \
          --volume-key-file <(echo -n "${volumeKey}") \
          $out
      '';

  commonMachine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.cryptsetup ];
      virtualisation.memorySize = memorySizeMiB;
      virtualisation.qemu.drives = [
        {
          name = "luks";
          file = "${luksImage}";
          driveExtraOpts = {
            format = "raw";
            readonly = "on";
          };
        }
      ];
    };
in
{
  name = "luks-suspend";
  meta.maintainers = with lib.maintainers; [ iblech ];

  nodes = {
    # Variant 1: LUKS volume opened after boot via the cryptsetup CLI.
    cli = commonMachine;

    # Variant 2: LUKS volume opened during boot by systemd-cryptsetup,
    # driven by the native NixOS LUKS module.
    native =
      { pkgs, lib, ... }:
      {
        imports = [ commonMachine ];
        boot.initrd.systemd.enable = true;

        # The test framework's qemu-vm module force-clears
        # boot.initrd.luks.devices via mkVMOverride (priority 10) when
        # virtualisation.useDefaultFilesystems is on (the default).
        # Our setting should have priority.
        boot.initrd.luks.devices = lib.mkOverride 5 {
          foo = {
            device = "/dev/disk/by-uuid/${luksUUID}";
            keyFile = "/etc/luks-foo.key";
          };
        };

        # Will produce (harmless) warnings about a world-readable keyFile.
        boot.initrd.systemd.contents."/etc/luks-foo.key".source = pkgs.writeText "luks-foo-key" "abc";
      };
  };

  testScript = ''
    import mmap

    MEM_BYTES = ${toString memorySizeMiB} * 1024 * 1024
    VOLUME_KEY = b"${volumeKey}"
    LUKS_DEV = "/dev/disk/by-uuid/${luksUUID}"

    def count_occurrences(dump_path, needle):
        count = 0
        with open(dump_path, "rb") as f:
            with mmap.mmap(f.fileno(), 0, prot=mmap.PROT_READ) as m:
                i = m.find(needle)
                while i != -1:
                    count += 1
                    i = m.find(needle, i + 1)
        return count

    def dump_and_count(machine, label):
        path = machine.state_dir / f"ram-{machine.name}-{label}.raw"
        reply = machine.send_monitor_command(f'pmemsave 0 {MEM_BYTES} "{path}"')
        if not path.exists():
            raise Exception(f"pmemsave wrote no dump; monitor replied: {reply!r}")
        full = count_occurrences(path, VOLUME_KEY)
        first = count_occurrences(path, VOLUME_KEY[:32])
        second = count_occurrences(path, VOLUME_KEY[32:])
        path.unlink()
        print(
            f"[{machine.name}/{label}] volume-key copies in RAM: "
            f"full={full} first-half={first} second-half={second}"
        )
        return full, first, second

    def check_suspend_wipes_key(machine):
        # Precondition: `machine` reached multi-user.target with the LUKS
        # volume open as /dev/mapper/foo.
        machine.succeed("test -b /dev/mapper/foo")

        # Give kernel-keyring garbage collection time to run.
        machine.sleep(10)

        before_full, before_first, before_second = dump_and_count(machine, "before-suspend")
        assert (before_full, before_first, before_second) == (0, 1, 1), (
          f"[{machine.name}] expected exactly one copy of the two parts of the volume key each "
          f"while the volume is open, found {before_full} / {before_first} / {before_second}"
        )

        # Suspend the volume -- this must wipe the key from kernel memory.
        machine.succeed("cryptsetup luksSuspend foo")

        after_full, after_first, after_second = dump_and_count(machine, "after-suspend")
        assert (after_full, after_first, after_second) == (0, 0, 0), (
            f"[{machine.name}] volume key material still present in RAM after luksSuspend "
            f"(full={after_full} first-half={after_first} second-half={after_second}) "
            f"-- key-wipe bug is present"
        )

    # Variant 1
    cli.start()
    cli.wait_for_unit("multi-user.target")
    cli.wait_for_file(LUKS_DEV)
    cli.succeed(f"echo -n abc | cryptsetup luksOpen {LUKS_DEV} foo")
    check_suspend_wipes_key(cli)

    # Variant 2
    native.start()
    native.wait_for_unit("multi-user.target")
    check_suspend_wipes_key(native)
  '';
}
