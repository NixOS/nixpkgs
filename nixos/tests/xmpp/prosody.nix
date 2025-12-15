{ ... }:

let
  cert =
    pkgs:
    pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
      openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -days 365 \
        -subj '/C=GB/CN=example.com/CN=uploads.example.com/CN=conference.example.com' -addext "subjectAltName = DNS:example.com,DNS:uploads.example.com,DNS:conference.example.com"
      mkdir -p $out
      cp key.pem cert.pem $out
    '';

  # Creates and set password for the 2 xmpp test users.
  #
  # Doing that in a bash script instead of doing that in the test
  # script allow us to easily provision the users when running that
  # test interactively.
  createUsers =
    pkgs:
    pkgs.writeShellScriptBin "create-prosody-users" ''
      set -e
      prosodyctl register cthon98 example.com nothunter2
      prosodyctl register azurediamond example.com hunter2
    '';
  # Deletes the test users.
  delUsers =
    pkgs:
    pkgs.writeShellScriptBin "delete-prosody-users" ''
      set -e
      prosodyctl deluser cthon98@example.com
      prosodyctl deluser azurediamond@example.com
    '';
in
{
  name = "prosody";
  nodes = {
    client-a =
      { nodes, pkgs, ... }:
      {
        security.pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
        networking.extraHosts = ''
          ${nodes.server.networking.primaryIPAddress} example.com
        '';

        imports = [ ./go-sendxmpp-listen.nix ];
      };

    client-b =
      {
        nodes,
        pkgs,
        ...
      }:
      {
        security.pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
        networking.extraHosts = ''
          ${nodes.server.networking.primaryIPAddress} example.com
          ${nodes.server.networking.primaryIPAddress} conference.example.com
          ${nodes.server.networking.primaryIPAddress} uploads.example.com
        '';
        environment.systemPackages = [
          (pkgs.callPackage ./xmpp-sendmessage.nix { connectTo = "example.com"; })
        ];
      };

    server =
      { config, pkgs, ... }:
      {
        security.pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
        networking.extraHosts = ''
          ${config.networking.primaryIPAddress} example.com
          ${config.networking.primaryIPAddress} conference.example.com
          ${config.networking.primaryIPAddress} uploads.example.com
        '';
        networking.firewall.enable = false;
        environment.systemPackages = [
          (createUsers pkgs)
          (delUsers pkgs)
        ];
        services.prosody = {
          enable = true;
          ssl.cert = "${cert pkgs}/cert.pem";
          ssl.key = "${cert pkgs}/key.pem";
          virtualHosts.example = {
            domain = "example.com";
            enabled = true;
            ssl.cert = "${cert pkgs}/cert.pem";
            ssl.key = "${cert pkgs}/key.pem";
          };
          muc = [
            {
              domain = "conference.example.com";
            }
          ];
          httpFileShare = {
            domain = "uploads.example.com";
          };
        };
      };
  };

  testScript = _: ''
    # Check with sqlite storage
    start_all()
    server.wait_for_unit("prosody.service")
    server.succeed('prosodyctl status | grep "Prosody is running"')

    server.succeed("create-prosody-users")

    for machine in client_a, client_b:
      machine.systemctl("start network-online.target")
      machine.wait_for_unit("network-online.target")

    client_a.wait_for_unit("go-sendxmpp-listen")
    client_b.succeed("send-message")

    client_a.wait_until_succeeds(
      "journalctl -o cat -u go-sendxmpp-listen.service | grep 'cthon98@example.com: Hello, this is dog.'"
    )

    server.succeed("delete-prosody-users")
  '';
}
