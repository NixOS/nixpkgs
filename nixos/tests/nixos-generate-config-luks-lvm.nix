import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "nixos-generate-config-luks-lvm";
    meta.maintainers = with lib.maintainers; [ ];

    nodes.machine =
      { pkgs, ... }:
      {
        imports = [ ./common/auto-format-root-device.nix ];

        virtualisation = {
          emptyDiskImages = [
            1024 # vdb - for LVM-over-LUKS
            1024 # vdc - for LUKS-over-LVM
          ];
          useBootLoader = true;
          useEFIBoot = true;
          mountHostNixStore = true;
        };
        boot.loader.systemd-boot.enable = true;
        boot.kernelParams = lib.mkOverride 5 [ "console=tty1" ];

        environment.systemPackages = with pkgs; [
          cryptsetup
          lvm2
        ];
      };

    testScript = ''
      # Setup helper functions
      def setup_lvm_over_luks():
          """
          Create an LVM-over-LUKS setup (LUKS → LVM):
          /dev/vdb → [LUKS encryption] → /dev/mapper/cryptlvm → [LVM PV/VG] →
                                                               → /dev/mapper/vg0-root
                                                               → /dev/mapper/vg0-home
          """
          machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -")
          machine.succeed("echo -n supersecret | cryptsetup luksOpen /dev/vdb cryptlvm -")

          # Create LVM structure on the LUKS container
          machine.succeed("pvcreate /dev/mapper/cryptlvm")
          machine.succeed("vgcreate vg0 /dev/mapper/cryptlvm")
          machine.succeed("lvcreate -L 512M -n root vg0")
          machine.succeed("lvcreate -L 256M -n home vg0")

          # Format the volumes
          machine.succeed("mkfs.ext4 -L root /dev/mapper/vg0-root")
          machine.succeed("mkfs.ext4 -L home /dev/mapper/vg0-home")

          # Mount them temporarily
          machine.succeed("mkdir -p /mnt/{root,home}")
          machine.succeed("mount /dev/mapper/vg0-root /mnt/root")
          machine.succeed("mount /dev/mapper/vg0-home /mnt/home")

          # Create some test files to verify later
          machine.succeed("echo 'LVM-over-LUKS root' > /mnt/root/testfile")
          machine.succeed("echo 'LVM-over-LUKS home' > /mnt/home/testfile")

      def setup_luks_over_lvm():
          """
          Create a LUKS-over-LVM setup (LVM → LUKS):
          /dev/vdc → [LVM PV/VG] → /dev/mapper/vg1-encrypt → [LUKS encryption] → /dev/mapper/cryptroot
          """
          # Create LVM structure directly on the disk
          machine.succeed("pvcreate /dev/vdc")
          machine.succeed("vgcreate vg1 /dev/vdc")
          machine.succeed("lvcreate -L 512M -n encrypt vg1")

          # Add LUKS on top of LVM
          machine.succeed("echo -n othersecret | cryptsetup luksFormat -q --iter-time=1 /dev/mapper/vg1-encrypt -")
          machine.succeed("echo -n othersecret | cryptsetup luksOpen /dev/mapper/vg1-encrypt cryptroot -")

          # Format the encrypted volume
          machine.succeed("mkfs.ext4 -L cryptroot /dev/mapper/cryptroot")

          # Mount it temporarily
          machine.succeed("mkdir -p /mnt/cryptroot")
          machine.succeed("mount /dev/mapper/cryptroot /mnt/cryptroot")

          # Create a test file
          machine.succeed("echo 'LUKS-over-LVM data' > /mnt/cryptroot/testfile")

      # Start machine and wait for it to be ready
      machine.start()
      machine.wait_for_unit("multi-user.target")

      # Set up our test disk configurations
      setup_lvm_over_luks()
      setup_luks_over_lvm()

      # Run nixos-generate-config to generate the configuration
      machine.succeed("mkdir -p /etc/nixos-test")
      machine.succeed("nixos-generate-config --dir /etc/nixos-test")

      # Verify the generated hardware-configuration.nix
      hardware_config = machine.succeed("cat /etc/nixos-test/hardware-configuration.nix")
      print("==================== HARDWARE CONFIG START ====================")
      print(hardware_config)
      print("==================== HARDWARE CONFIG END ====================")

      # Check for LVM-over-LUKS configuration (LUKS → LVM)
      # Verify that LUKS device is properly detected and preLVM is true
      if "boot.initrd.luks.devices.\"cryptlvm\"" not in hardware_config:
          raise Exception("LVM-over-LUKS setup: LUKS device 'cryptlvm' not found in config")

      if "preLVM = true" not in hardware_config:
          raise Exception("LVM-over-LUKS setup: LUKS device should have preLVM = true")

      # Check for LUKS-over-LVM configuration (LVM → LUKS)
      # Verify that LUKS device is properly detected and preLVM is false
      if "boot.initrd.luks.devices.\"cryptroot\"" not in hardware_config:
          raise Exception("LUKS-over-LVM setup: LUKS device 'cryptroot' not found in config")

      if "preLVM = false" not in hardware_config:
          raise Exception("LUKS-over-LVM setup: LUKS device should have preLVM = false")

      # Make sure the filesystem entries were properly generated for both setups
      # First check that all required mountpoints are present
      mountpoints = [
          "fileSystems.\"/mnt/root\"",
          "fileSystems.\"/mnt/home\"",
          "fileSystems.\"/mnt/cryptroot\""
      ]

      for mountpoint in mountpoints:
          if mountpoint not in hardware_config:
              raise Exception(f"Filesystem mount {mountpoint} not found in config")

      # Now get the UUIDs of all our created devices to make sure they're used in the config
      root_uuid = machine.succeed("blkid -s UUID -o value /dev/mapper/vg0-root").strip()
      home_uuid = machine.succeed("blkid -s UUID -o value /dev/mapper/vg0-home").strip()
      cryptroot_uuid = machine.succeed("blkid -s UUID -o value /dev/mapper/cryptroot").strip()

      # Check that these UUIDs appear in the hardware config, either as /dev/disk/by-uuid/UUID or as "UUID=UUID"
      for uuid in [root_uuid, home_uuid, cryptroot_uuid]:
          if f"/dev/disk/by-uuid/{uuid}" not in hardware_config and f"UUID={uuid}" not in hardware_config:
              raise Exception(f"UUID {uuid} not found in configuration - stable device paths are not being used properly")

      # Verify the mounts work by checking the content of the test files
      machine.succeed("mkdir -p /mnt/test/root /mnt/test/home /mnt/test/cryptroot")
      machine.succeed("mount /dev/mapper/vg0-root /mnt/test/root")
      machine.succeed("mount /dev/mapper/vg0-home /mnt/test/home")
      machine.succeed("mount /dev/mapper/cryptroot /mnt/test/cryptroot")

      root_content = machine.succeed("cat /mnt/test/root/testfile").strip()
      home_content = machine.succeed("cat /mnt/test/home/testfile").strip()
      cryptroot_content = machine.succeed("cat /mnt/test/cryptroot/testfile").strip()

      if root_content != "LVM-over-LUKS root":
          raise Exception(f"Wrong content in root testfile: {root_content}")

      if home_content != "LVM-over-LUKS home":
          raise Exception(f"Wrong content in home testfile: {home_content}")

      if cryptroot_content != "LUKS-over-LVM data":
          raise Exception(f"Wrong content in cryptroot testfile: {cryptroot_content}")

      print("All tests passed!")
    '';
  }
)
