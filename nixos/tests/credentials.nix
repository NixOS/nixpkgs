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

  common-credentials = {
    secret-default-mechanism = {
      text = "default-mechanism";
    };
    secret-file-nix-store = {
      source = pkgs.writeText "secret-file-nix-store" secret-file;
    };
    secret-file-host = {
      source = "./secret-file-host";
    };
    secret-file-host-binary = {
      source = "./secret-file-host-binary";
    };
  };
in

{
  name = "credentials-${mechanism}";

  meta.maintainers = with lib.maintainers; [ arianvp ];

  # No VM<->container traffic in this test; credentials are static.
  requiredFeatures.devnet = lib.mkForce false;

  nodes.vm = {
    virtualisation.credentials = common-credentials // {
      secret = {
        inherit mechanism;
        text = secret;
      };
    };
  };

  containers.container = {
    virtualisation.credentials = common-credentials // {
      secret = {
        text = secret;
      };
    };
  };

  testScript = ''
    import base64

    secret_file_host = "baz"
    # Binary data with null bytes, high bytes, and other problematic characters.
    secret_file_host_binary = bytes([
      0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
      0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
      0xDE, 0xAD, 0xBE, 0xEF,
      0xFF, 0xFE, 0xFD, 0xFC,
      0x00, 0x00, 0x00, 0x00,
      0x80, 0x81, 0x82, 0x83,
    ])

    def assert_credentials(m):
      with open(m.state_dir / "secret-file-host", "w") as f:
        f.write(secret_file_host)
      with open(m.state_dir / "secret-file-host-binary", "wb") as f2:
        f2.write(secret_file_host_binary)

      t.assertEqual(
          m.succeed("systemd-creds --system cat secret").strip(),
          "foo\nbar\nbaz",
      )
      t.assertEqual(
          m.succeed("systemd-creds --system cat secret-default-mechanism").strip(),
          "default-mechanism",
      )
      t.assertEqual(
          m.succeed("systemd-creds --system cat secret-file-nix-store").strip(),
          "${secret-file}",
      )
      t.assertEqual(
          m.succeed("systemd-creds --system cat secret-file-host").strip(),
          secret_file_host,
      )
      result = m.succeed(
          "systemd-creds --system cat secret-file-host-binary --transcode=base64"
      ).strip()
      expected = base64.b64encode(secret_file_host_binary).decode("ascii")
      t.assertEqual(
          result,
          expected,
          f"Binary credential mismatch: got {result}, expected {expected}",
      )

    assert_credentials(vm)
    assert_credentials(container)
  '';
}
