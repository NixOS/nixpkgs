import ../make-test-python.nix (
  { lib, pkgs, ... }:
  let
    genNodeId =
      name:
      pkgs.runCommand "syncthing-test-certs-${name}" { } ''
        mkdir -p $out
        ${pkgs.syncthing}/bin/syncthing generate --config=$out
        ${pkgs.libxml2}/bin/xmllint --xpath 'string(configuration/device/@id)' $out/config.xml > $out/id
      '';
    idA = genNodeId "a";
    idB = genNodeId "b";
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
          settings = {
            devices.b = {
              id = lib.fileContents "${idB}/id";
            };
            folders.foo = {
              path = "/var/lib/syncthing/foo";
              devices = [ "b" ];
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
          settings = {
            devices.a = {
              id = lib.fileContents "${idA}/id";
            };
            folders.foo = {
              path = "/var/lib/syncthing/foo";
              devices = [ "a" ];
            };
          };
        };
      };
    };

    testScript = ''
      start_all()
      a.wait_for_unit("syncthing.service")
      b.wait_for_unit("syncthing.service")
      a.wait_for_open_port(22000)
      b.wait_for_open_port(22000)
      a.wait_for_file("/var/lib/syncthing/foo")
      b.wait_for_file("/var/lib/syncthing/foo")
      a.succeed("echo a2b > /var/lib/syncthing/foo/a2b")
      b.succeed("echo b2a > /var/lib/syncthing/foo/b2a")
      a.wait_for_file("/var/lib/syncthing/foo/b2a")
      b.wait_for_file("/var/lib/syncthing/foo/a2b")
    '';
  }
)
