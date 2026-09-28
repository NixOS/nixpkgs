{ lib, pkgs, ... }:
let
  nodeA = ./test-nodes/a;
  nodeB = ./test-nodes/b;
  nodeC = ./test-nodes/c;
  testPassword = "it's a secret";
in
{
  name = "syncthing-folders";
  meta.maintainers = with pkgs.lib.maintainers; [ zarelit ];

  nodes = {
    a =
      { config, ... }:
      {
        environment.etc.bar-encryption-password.text = testPassword;
        services.syncthing = {
          enable = true;
          openDefaultPorts = true;
          cert = "${nodeA}/cert.pem";
          key = "${nodeA}/key.pem";
          guiAddress = "unix:///run/syncthing/syncthing.sock";
          settings = {
            devices.b.id = lib.fileContents "${nodeB}/id";
            devices.c.id = lib.fileContents "${nodeC}/id";
            folders.foo = {
              path = "/var/lib/syncthing/foo";
              devices = [ "b" ];
            };
            folders.bar = {
              path = "/var/lib/syncthing/bar";
              devices = [
                {
                  name = "c";
                  encryptionPasswordFile = "/etc/${config.environment.etc.bar-encryption-password.target}";
                }
              ];
            };
            folders.baz = {
              path = "/var/lib/syncthing/baz";
              devices = [
                "b"
                "c"
              ];
              ignorePatterns = [ ];
            };
            folders."foo bar" = {
              path = "/var/lib/syncthing/foo-bar";
              devices = [
                "b"
              ];
            };
          };
        };
      };
    b =
      { config, ... }:
      {
        environment.etc.bar-encryption-password.text = testPassword;
        services.syncthing = {
          enable = true;
          openDefaultPorts = true;
          cert = "${nodeB}/cert.pem";
          key = "${nodeB}/key.pem";
          settings = {
            devices.a.id = lib.fileContents "${nodeA}/id";
            devices.c.id = lib.fileContents "${nodeC}/id";
            folders.foo = {
              path = "/var/lib/syncthing/foo";
              devices = [ "a" ];
            };
            folders.bar = {
              path = "/var/lib/syncthing/bar";
              devices = [
                {
                  name = "c";
                  encryptionPasswordFile = "/etc/${config.environment.etc.bar-encryption-password.target}";
                }
              ];
            };
            folders.baz = {
              path = "/var/lib/syncthing/baz";
              devices = [
                "a"
                "c"
              ];
              ignorePatterns = [
                "notB"
              ];
            };
            # Test how we handle white spaces in folder IDs
            folders."foo bar" = {
              path = "/var/lib/syncthing/foo-bar";
              devices = [
                "a"
              ];
              ignorePatterns = [
                "notB"
                # Just test that an apostrophe doesn't break the curl config
                # commands. See: https://github.com/NixOS/nixpkgs/issues/554744
                "apostrophe'"
              ];
            };
          };
        };
      };
    c = {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        cert = "${nodeC}/cert.pem";
        key = "${nodeC}/key.pem";
        settings = {
          devices.a.id = lib.fileContents "${nodeA}/id";
          devices.b.id = lib.fileContents "${nodeB}/id";
          folders.bar = {
            path = "/var/lib/syncthing/bar";
            devices = [
              "a"
              "b"
            ];
            type = "receiveencrypted";
          };
          folders.baz = {
            path = "/var/lib/syncthing/baz";
            devices = [
              "a"
              "b"
            ];
            ignorePatterns = [
              "notC"
            ];
          };
        };
      };
    };
  };

  # Run from the root of the nixpkgs repository with
  #
  #     nix-build -A nixosTests.syncthing-folders.genNodeData &&
  #       ./result/bin/genNodeData.sh
  #
  # This generates new keys, certificates, and overall Syncthing config, and
  # updates the certificate and key files and the ID file extracted from the
  # overall Syncthing config file.
  passthru.genNodeData = pkgs.writeShellApplication {
    name = "genNodeData.sh";
    runtimeInputs = with pkgs; [
      syncthing
      libxml2
    ];
    text = ''
      rm -r nixos/tests/syncthing/test-nodes
      mkdir nixos/tests/syncthing/test-nodes
      cd nixos/tests/syncthing/test-nodes

      for d in a b c; do
        mkdir -- "$d"
        syncthing generate --home="$d"
        xmllint --xpath 'string(configuration/device/@id)' "$d"/config.xml >"$d"/id
        rm -f -- "$d"/.syncthing.tmp.* "$d"/config.xml
      done
    '';
  };

  testScript = ''
    start_all()

    a.wait_for_unit("syncthing.service")
    b.wait_for_unit("syncthing.service")
    c.wait_for_unit("syncthing.service")
    a.wait_for_open_port(22000)
    b.wait_for_open_port(22000)
    c.wait_for_open_port(22000)

    # Test foo

    a.wait_for_file("/var/lib/syncthing/foo")
    b.wait_for_file("/var/lib/syncthing/foo")

    a.succeed("echo a2b > /var/lib/syncthing/foo/a2b")
    b.succeed("echo b2a > /var/lib/syncthing/foo/b2a")

    a.wait_for_file("/var/lib/syncthing/foo/b2a")
    b.wait_for_file("/var/lib/syncthing/foo/a2b")

    # Test bar

    a.wait_for_file("/var/lib/syncthing/bar")
    b.wait_for_file("/var/lib/syncthing/bar")
    c.wait_for_file("/var/lib/syncthing/bar")

    a.succeed("echo plaincontent > /var/lib/syncthing/bar/plainname")

    # B should be able to decrypt, check that content of file matches
    b.wait_for_file("/var/lib/syncthing/bar/plainname")
    file_contents = b.succeed("cat /var/lib/syncthing/bar/plainname")
    assert "plaincontent\n" == file_contents, f"Unexpected file contents: {file_contents=}"

    # Bar on C is untrusted, check that content is not in cleartext
    c.fail("grep -R plaincontent /var/lib/syncthing/bar")

    # Test baz

    a.wait_for_file("/var/lib/syncthing/baz")
    b.wait_for_file("/var/lib/syncthing/baz")
    c.wait_for_file("/var/lib/syncthing/baz")

    # A creates the file notB, C should get it, B should ignore it
    a.succeed("echo notB > /var/lib/syncthing/baz/notB")
    a.succeed("echo controlA > /var/lib/syncthing/baz/controlA")
    c.wait_for_file("/var/lib/syncthing/baz/notB")
    c.wait_for_file("/var/lib/syncthing/baz/controlA")
    b.wait_for_file("/var/lib/syncthing/baz/controlA")

    # B creates the file notC, A should get it, C should ignore it
    b.succeed("echo notC > /var/lib/syncthing/baz/notC")
    b.succeed("echo controlB > /var/lib/syncthing/baz/controlB")
    a.wait_for_file("/var/lib/syncthing/baz/notC")
    a.wait_for_file("/var/lib/syncthing/baz/controlB")
    c.wait_for_file("/var/lib/syncthing/baz/controlB")

    # Check that files have been correctly ignored
    b.fail("cat /var/lib/syncthing/baz/notB")
    c.fail("cat /var/lib/syncthing/baz/notC")

    # Test foo bar

    a.wait_for_file("/var/lib/syncthing/foo-bar")
    b.wait_for_file("/var/lib/syncthing/foo-bar")

    a.succeed("echo a2b > /var/lib/syncthing/foo-bar/a2b")
    a.succeed("echo a2b > /var/lib/syncthing/foo-bar/notB")
    b.succeed("echo b2a > /var/lib/syncthing/foo-bar/b2a")

    a.wait_for_file("/var/lib/syncthing/foo-bar/b2a")
    b.wait_for_file("/var/lib/syncthing/foo-bar/a2b")

    # Check that file has been correctly ignored
    b.fail("cat /var/lib/syncthing/foo-bar/notB")
  '';
}
