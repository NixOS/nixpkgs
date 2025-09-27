{ lib, pkgs, ... }:

let
  secret = ''
    foo
    bar
    baz
  '';
  secret-file = "bar";
in

{
  name = "qemu-vm-credentials";

  meta.maintainers = with lib.maintainers; [ arianvp ];

  nodes = {
    machine = {
      virtualisation.credentials = {
        secret.text = secret;
        secret-file-nix-store.source = pkgs.writeText "secret-file-nix-store" secret-file;
        secret-file-host.source = "./secret-file-host";
        secret-file-host-binary = {
          binary = true;
          source = "./secret-file-host-binary";
        };
      };
    };
  };

  testScript = ''
    import base64
    secret_file_host = "baz"
    secret_file_host_binary = bytes([0x00, 0x01, 0x02, 0xFF, 0xFE, 0xFD, 0x7F, 0x80, 0x81])
    with open(machine.state_dir / "secret-file-host", "w") as f:
      f.write(secret_file_host)
    with open(machine.state_dir / "secret-file-host-binary", "wb") as f2:
      f2.write(secret_file_host_binary)

    t.assertEqual(machine.succeed("systemd-creds --system cat secret").strip(), "foo\nbar\nbaz")
    t.assertEqual(machine.succeed("systemd-creds --system cat secret-file-nix-store").strip(), "${secret-file}")
    t.assertEqual(machine.succeed("systemd-creds --system cat secret-file-host").strip(), secret_file_host)

    secret_file_host_binary_b64 = base64.b64encode(secret_file_host_binary).decode('ascii')
    t.assertEqual(machine.succeed("systemd-creds --system cat secret-file-host-binary --transcode=base64").strip(), secret_file_host_binary_b64)
  '';
}
