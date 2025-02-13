let
  cert =
    pkgs:
    pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
      openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=example.com/CN=uploads.example.com/CN=conference.example.com' -days 36500
      mkdir -p $out
      cp key.pem cert.pem $out
    '';
  createUsers =
    pkgs:
    pkgs.writeScriptBin "create-prosody-users" ''
      #!${pkgs.bash}/bin/bash
      set -e

      # Creates and set password for the 2 xmpp test users.
      #
      # Doing that in a bash script instead of doing that in the test
      # script allow us to easily provision the users when running that
      # test interactively.

      prosodyctl register cthon98 example.com nothunter2
      prosodyctl register azurediamond example.com hunter2
    '';
  delUsers =
    pkgs:
    pkgs.writeScriptBin "delete-prosody-users" ''
      #!${pkgs.bash}/bin/bash
      set -e

      # Deletes the test users.
      #
      # Doing that in a bash script instead of doing that in the test
      # script allow us to easily provision the users when running that
      # test interactively.

      prosodyctl deluser cthon98@example.com
      prosodyctl deluser azurediamond@example.com
    '';
in
import ../make-test-python.nix {
  name = "prosody";
  nodes = {
    client =
      {
        nodes,
        pkgs,
        config,
        ...
      }:
      {
        security.pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
        console.keyMap = "fr-bepo";
        networking.extraHosts = ''
          ${nodes.server.config.networking.primaryIPAddress} example.com
          ${nodes.server.config.networking.primaryIPAddress} conference.example.com
          ${nodes.server.config.networking.primaryIPAddress} uploads.example.com
        '';
        environment.systemPackages = [
          (pkgs.callPackage ./xmpp-sendmessage.nix { connectTo = "example.com"; })
        ];
      };
    server =
      { config, pkgs, ... }:
      {
        security.pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
        console.keyMap = "fr-bepo";
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
          uploadHttp = {
            domain = "uploads.example.com";
          };
        };
      };
  };

  testScript =
    { nodes, ... }:
    ''
      # Check with sqlite storage
      start_all()
      server.wait_for_unit("prosody.service")
      server.succeed('prosodyctl status | grep "Prosody is running"')

      server.succeed("create-prosody-users")
      client.succeed("send-message")
      server.succeed("delete-prosody-users")
    '';
}
