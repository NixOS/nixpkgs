{
  lib,
  pkgs,
  mechanism,
  ...
}:

let
  secret = ''
    foo
    bar
    baz
  '';
  secret-file = "bar";
in

{
  name = "qemu-vm-credentials-${mechanism}";

  meta.maintainers = with lib.maintainers; [ arianvp ];

  nodes = {
    machine = {
      virtualisation.credentials = {
        secret = {
          inherit mechanism;
          text = secret;
        };
        secret-default-mechanism = {
          text = "default-mechanism";
        };
        secret-file-nix-store = {
          inherit mechanism;
          source = pkgs.writeText "secret-file-nix-store" secret-file;
        };
        secret-file-host = {
          inherit mechanism;
          source = "./secret-file-host";
        };
        secret-file-host-binary = {
          inherit mechanism;
          source = "./secret-file-host-binary";
        };
      };
    };
  };

  testScript = ''
    import base64
    secret_file_host = "baz"
    # Binary data with null bytes, high bytes, and all sorts of problematic characters
    secret_file_host_binary = bytes([
      0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,  # null and control chars
      0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
      0xDE, 0xAD, 0xBE, 0xEF,                          # classic binary pattern
      0xFF, 0xFE, 0xFD, 0xFC,                          # high bytes
      0x00, 0x00, 0x00, 0x00,                          # multiple nulls
      0x80, 0x81, 0x82, 0x83,                          # more high bytes
    ])

    with open(machine.state_dir / "secret-file-host", "w") as f:
      f.write(secret_file_host)
    with open(machine.state_dir / "secret-file-host-binary", "wb") as f2:
      f2.write(secret_file_host_binary)


    # Test text credential
    t.assertEqual(machine.succeed("systemd-creds --system cat secret").strip(), "foo\nbar\nbaz")

    t.assertEqual(machine.succeed("systemd-creds --system cat secret-default-mechanism").strip(), "default-mechanism")

    # Test credential from nix store
    t.assertEqual(machine.succeed("systemd-creds --system cat secret-file-nix-store").strip(), "${secret-file}")

    # Test credential from host file
    t.assertEqual(machine.succeed("systemd-creds --system cat secret-file-host").strip(), secret_file_host)

    # Test binary credential - verify exact binary content
    result = machine.succeed("systemd-creds --system cat secret-file-host-binary --transcode=base64").strip()
    expected = base64.b64encode(secret_file_host_binary).decode('ascii')
    t.assertEqual(result, expected, f"Binary credential mismatch: got {result}, expected {expected}")
  '';
}
