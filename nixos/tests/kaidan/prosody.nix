{
  config,
  pkgs,
  lib,
  ...
}:
# NOTE: most of this is taken from the prosody test
let
  cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
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
  createUsers = pkgs.writeShellScriptBin "create-prosody-users" ''
    set -e
    prosodyctl register alice example.com foobar
    prosodyctl register john example.com foobar
  '';
in
{
  # Make the self-signed certificates work
  security.pki.certificateFiles = [ "${cert}/cert.pem" ];

  networking.extraHosts = ''
    ${config.networking.primaryIPAddress} example.com
    ${config.networking.primaryIPAddress} conference.example.com
    ${config.networking.primaryIPAddress} uploads.example.com
  '';

  environment.systemPackages = [
    createUsers
  ];

  # Configure Prosody with self-signed certificates
  services.prosody = {
    enable = true;
    ssl.cert = "${cert}/cert.pem";
    ssl.key = "${cert}/key.pem";
    virtualHosts.example = {
      enabled = true;
      domain = "example.com";
      ssl.cert = "${cert}/cert.pem";
      ssl.key = "${cert}/key.pem";
    };
    muc = [ { domain = "conference.example.com"; } ];
    httpFileShare = {
      domain = "uploads.example.com";
    };
  };

  networking.hosts."127.0.0.1" = [ "example.com" ];
}
