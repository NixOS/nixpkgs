{ lib, ... }: {
  name = "apfs";
  meta.maintainers = with lib.maintainers; [ Luflosi ];

  nodes.machine = {
    virtualisation.emptyDiskImages = [ 1024 ];

    boot.supportedFilesystems = [ "apfs" ];
  };

  testScript = ''
    machine.wait_for_unit("basic.target")
    machine.succeed("mkdir /tmp/mnt")

    with subtest("mkapfs refuses to work with a label that is too long"):
      machine.fail( "mkapfs -L '000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122232425262728292A2B2C2D2E2F303132333435363738393A3B3C3D3E3F404142434445464748494A4B4C4D4E4F505152535455565758595A5B5C5D5E5F606162636465666768696A6B6C6D6E6F707172737475767778797A7B7C7D7E7F' /dev/vdb")

    with subtest("mkapfs works with the maximum label length"):
      machine.succeed("mkapfs -L '000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122232425262728292A2B2C2D2E2F303132333435363738393A3B3C3D3E3F404142434445464748494A4B4C4D4E4F505152535455565758595A5B5C5D5E5F606162636465666768696A6B6C6D6E6F707172737475767778797A7B7C7D7E7' /dev/vdb")

    with subtest("Enable case sensitivity and normalization sensitivity"):
      machine.succeed(
          "mkapfs -s -z /dev/vdb",
          "mount -o cknodes,readwrite /dev/vdb /tmp/mnt",
          "echo 'Hello World 1' > /tmp/mnt/test.txt",
          "[ ! -f /tmp/mnt/TeSt.TxT ] || false", # Test case sensitivity
          "echo 'Hello World 1' | diff - /tmp/mnt/test.txt",
          "echo 'Hello World 2' > /tmp/mnt/\u0061\u0301.txt",
          "echo 'Hello World 2' | diff - /tmp/mnt/\u0061\u0301.txt",
          "[ ! -f /tmp/mnt/\u00e1.txt ] || false", # Test Unicode normalization sensitivity
          "umount /tmp/mnt",
          "apfsck /dev/vdb",
      )
    with subtest("Disable case sensitivity and normalization sensitivity"):
      machine.succeed(
          "mkapfs /dev/vdb",
          "mount -o cknodes,readwrite /dev/vdb /tmp/mnt",
          "echo 'bla bla bla' > /tmp/mnt/Test.txt",
          "echo -n 'Hello World' > /tmp/mnt/test.txt",
          "echo ' 1' >> /tmp/mnt/TEST.TXT",
          "umount /tmp/mnt",
          "apfsck /dev/vdb",
          "mount -o cknodes,readwrite /dev/vdb /tmp/mnt",
          "echo 'Hello World 1' | diff - /tmp/mnt/TeSt.TxT", # Test case insensitivity
          "echo 'Hello World 2' > /tmp/mnt/\u0061\u0301.txt",
          "echo 'Hello World 2' | diff - /tmp/mnt/\u0061\u0301.txt",
          "echo 'Hello World 2' | diff - /tmp/mnt/\u00e1.txt", # Test Unicode normalization
          "umount /tmp/mnt",
          "apfsck /dev/vdb",
      )
    with subtest("Snapshots"):
      machine.succeed(
          "mkapfs /dev/vdb",
          "mount -o cknodes,readwrite /dev/vdb /tmp/mnt",
          "echo 'Hello World' > /tmp/mnt/test.txt",
          "apfs-snap /tmp/mnt snap-1",
          "rm /tmp/mnt/test.txt",
          "umount /tmp/mnt",
          "mount -o cknodes,readwrite,snap=snap-1 /dev/vdb /tmp/mnt",
          "echo 'Hello World' | diff - /tmp/mnt/test.txt",
          "umount /tmp/mnt",
          "apfsck /dev/vdb",
      )
  '';
}
