{ pkgs, lib, ... }:
let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
  domainParts = lib.splitString "." domain;
  hostNamePart = builtins.head domainParts;
  domainSuffix = lib.concatStringsSep "." (builtins.tail domainParts);

  pass = "hunter2";
  network = "testnet";

  bouncerPort = 6697;
  ircdPort = 6667;
  uploadPort = 8080;
in
{
  name = "soju";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  containers = {
    client =
      { pkgs, lib, ... }:
      {
        networking.hostName = hostNamePart;
        networking.domain = domainSuffix;

        security.pki.certificateFiles = [ certs.ca.cert ];

        services.soju = {
          enable = true;
          adminSocket.enable = true;
          hostName = domain;
          tlsCertificate = certs.${domain}.cert;
          tlsCertificateKey = certs.${domain}.key;
          listen = [
            "irc+insecure://:${toString bouncerPort}"
            "https://:${toString uploadPort}"
          ];
          extraConfig = "file-upload fs uploads";
        };

        environment.systemPackages = with pkgs; [
          curl
          ii
        ];

        # This is deliberately not started automatically. We'll wait until
        # we have created the network, and then manually have this connect to the bouncer.
        systemd.services.ii-user1-bouncer = {
          environment.IRC_PASS = pass;
          serviceConfig.ExecStart = "${lib.getExe pkgs.ii} -s localhost -p ${toString bouncerPort} -n user1/${network} -k IRC_PASS -i /tmp/ii-user1-bouncer";
        };

        systemd.services.ii-user2-server = {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe pkgs.ii} -s server -n user2 -i /tmp/ii-user2-server";
            Restart = "on-failure";
          };
        };
      };

    server =
      { pkgs, ... }:
      {
        services.inspircd = {
          enable = true;
          package = pkgs.inspircdMinimal;
          config = ''
            <bind address="" port="${toString ircdPort}" type="clients">
            <connect name="main" allow="*" pingfreq="15">
          '';
        };
        networking.firewall.allowedTCPPorts = [ ircdPort ];
      };
  };

  testScript =
    let
      channel = "#test";
      message = "hello from user2";
      upload = "hello from the upload test";
      uploadFile = pkgs.writeText "soju-test-upload" upload;
    in
    ''
      import re

      start_all()

      client.wait_for_unit("soju.service")
      client.wait_for_file("/run/soju/admin")
      server.wait_for_unit("inspircd.service")

      with subtest("Create a user"):
        client.succeed("sojuctl user create -username user1 -password ${pass}")

      with subtest("Connect to the upstream IRC server"):
          client.succeed(
              "sojuctl user run user1 network create"
              " -addr irc+insecure://server:${toString ircdPort} -name ${network}"
          )
          client.wait_until_succeeds(
              "sojuctl user run user1 network status | grep -qi '\\bconnected\\b'"
          )

          status = client.succeed("sojuctl server status")
          assert "1 upstreams" in status, f"expected soju to report the upstream connection, got:\n{status}"

      with subtest("Send a message between two clients"):
          client.wait_for_unit("ii-user2-server.service")
          client.wait_for_file("/tmp/ii-user2-server/server/in")
          client.wait_for_file("/tmp/ii-user2-server/server/out")
          client.systemctl("start ii-user1-bouncer.service")
          client.wait_for_file("/tmp/ii-user1-bouncer/localhost/in")
          client.wait_for_file("/tmp/ii-user1-bouncer/localhost/out")

          client.succeed("echo '/j ${channel}' > /tmp/ii-user1-bouncer/localhost/in")
          client.wait_until_succeeds(
              "grep -q 'has joined' '/tmp/ii-user1-bouncer/localhost/${channel}/out'"
          )

          client.succeed("echo '/j ${channel}' > /tmp/ii-user2-server/server/in")
          client.wait_until_succeeds("grep -q 'has joined' '/tmp/ii-user2-server/server/${channel}/out'")

          client.succeed("echo '${message}' > '/tmp/ii-user2-server/server/${channel}/in'")
          client.wait_until_succeeds(
              "grep -q -- '${message}' '/tmp/ii-user1-bouncer/localhost/${channel}/out'"
          )

      with subtest("Send a file between two clients"):
          headers = client.succeed(
              "curl -sS -D- -o /dev/null"
              " -u user1:${pass}"
              " -H 'Content-Disposition: attachment; filename=\"upload.txt\"'"
              " --data-binary @${uploadFile}"
              " https://${domain}:${toString uploadPort}/uploads"
          )
          match = re.search(r"^location:\s*(\S+)", headers, re.IGNORECASE | re.MULTILINE)
          assert match, f"expected the upload to succeed (Location header), got:\n{headers}"

          downloaded = client.succeed(
              "curl -sS -f"
              f" https://${domain}:${toString uploadPort}{match.group(1)}"
          )
          assert downloaded == "${upload}", f"expected the downloaded file to match the upload, got:\n{downloaded}"

      with subtest("Logged messages survive a restart"):
          client.systemctl("restart soju.service")
          client.wait_for_unit("soju.service")
          client.wait_for_open_port(${toString bouncerPort})

          # ii does not support retrieving missed chat history after a disconnect,
          # so we just check that messages are written to disk as the next best thing.
          persisted = client.succeed("grep -r -- '${message}' /var/lib/soju/logs")
          assert persisted.strip() != "", "expected the relayed message to be persisted to disk"
    '';
}
