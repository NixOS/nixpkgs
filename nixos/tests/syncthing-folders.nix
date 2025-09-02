{ lib, pkgs, ... }:
let
  genNodeId =
    name:
    pkgs.runCommand "syncthing-test-certs-${name}" { } ''
      mkdir -p $out
      ${pkgs.syncthing}/bin/syncthing generate --home=$out
      ${pkgs.libxml2}/bin/xmllint --xpath 'string(configuration/device/@id)' $out/config.xml > $out/id
    '';
  idA = genNodeId "a";
  idB = genNodeId "b";
  idC = genNodeId "c";
  testPassword = "it's a secret";
in
{
  name = "syncthing";
  meta.maintainers = with pkgs.lib.maintainers; [ zarelit ];

  nodes = {
    a =
      { config, ... }:
      {
        environment.etc.bar-encryption-password.text = testPassword;
        services.syncthing = {
          enable = true;
          openDefaultPorts = true;
          cert = "${idA}/cert.pem";
          key = "${idA}/key.pem";
          settings = {
            devices.b.id = lib.fileContents "${idB}/id";
            devices.c.id = lib.fileContents "${idC}/id";
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
          cert = "${idB}/cert.pem";
          key = "${idB}/key.pem";
          settings = {
            devices.a.id = lib.fileContents "${idA}/id";
            devices.c.id = lib.fileContents "${idC}/id";
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
          };
        };
      };
    c = {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        cert = "${idC}/cert.pem";
        key = "${idC}/key.pem";
        settings = {
          devices.a.id = lib.fileContents "${idA}/id";
          devices.b.id = lib.fileContents "${idB}/id";
          folders.bar = {
            path = "/var/lib/syncthing/bar";
            devices = [
              "a"
              "b"
            ];
            type = "receiveencrypted";
          };
        };
      };
    };
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
  '';
}
