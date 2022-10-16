import ../make-test-python.nix ({ lib, pkgs, ... }:
  let
    genNodeId = name: pkgs.runCommand "syncthing-test-certs-${name}" { } ''
      mkdir -p $out
      ${pkgs.syncthing}/bin/syncthing generate --config=$out
      ${pkgs.libxml2}/bin/xmllint --xpath 'string(configuration/device/@id)' $out/config.xml > $out/id
    '';
    idA = genNodeId "a";
    idB = genNodeId "b";
    idC = genNodeId "c";
  in
  {
    name = "syncthing";
    meta.maintainers = with pkgs.lib.maintainers; [ zarelit ];

    nodes = {
      a = {
        services.syncthing = {
          enable = true;
          openDefaultPorts = true;
          cert = "${idA}/cert.pem";
          key = "${idA}/key.pem";
          devices.b.id = lib.fileContents "${idB}/id";
          devices.c.id = lib.fileContents "${idC}/id";
          folders = {
            foo = {
              path = "/var/lib/syncthing/foo";
              devices = [ "b" "c" ];
            };
          };
        };
      };
      b = {
        services.syncthing = {
          enable = true;
          openDefaultPorts = true;
          cert = "${idB}/cert.pem";
          key = "${idB}/key.pem";
          devices.a.id = lib.fileContents "${idA}/id";
          devices.c.id = lib.fileContents "${idC}/id";
          folders = {
            foo = {
              path = "/var/lib/syncthing/foo";
              devices = [ "a" "c" ];
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
          devices.a.id = lib.fileContents "${idA}/id";
          devices.b.id = lib.fileContents "${idB}/id";
          folders = {
            foo = {
              path = "/var/lib/syncthing/foo";
              devices = [ "a" "b" ];
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

      a.wait_for_file("/var/lib/syncthing/foo")
      b.wait_for_file("/var/lib/syncthing/foo")
      c.wait_for_file("/var/lib/syncthing/foo")

      a.succeed("echo a2bc > /var/lib/syncthing/foo/a2bc")
      b.succeed("echo b2ac > /var/lib/syncthing/foo/b2ac")

      a.wait_for_file("/var/lib/syncthing/foo/b2ac")
      b.wait_for_file("/var/lib/syncthing/foo/a2bc")
      c.wait_for_file("/var/lib/syncthing/foo/b2ac")
      c.wait_for_file("/var/lib/syncthing/foo/a2bc")

      # Foo on C is trusted, check content of file matches
      c.succeed("grep a2bc /var/lib/syncthing/foo/a2bc")
      c.succeed("grep b2ac /var/lib/syncthing/foo/b2ac")
    '';
  })
