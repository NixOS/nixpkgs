{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  stunnelCommon = {
    services.stunnel = {
      enable = true;
      user = "stunnel";
    };
    users.groups.stunnel = { };
    users.users.stunnel = {
      isSystemUser = true;
      group = "stunnel";
    };
  };
  makeCert = { config, pkgs, ... }: {
    system.activationScripts.create-test-cert = stringAfter [ "users" ] ''
      ${pkgs.openssl}/bin/openssl req -batch -x509 -newkey rsa -nodes -out /test-cert.pem -keyout /test-key.pem -subj /CN=${config.networking.hostName}
      ( umask 077; cat /test-key.pem /test-cert.pem > /test-key-and-cert.pem )
      chown stunnel /test-key.pem /test-key-and-cert.pem
    '';
  };
  serverCommon = { pkgs, ... }: {
    networking.firewall.allowedTCPPorts = [ 443 ];
    services.stunnel.servers.https = {
      accept = "443";
      connect = 80;
      cert = "/test-key-and-cert.pem";
    };
    systemd.services.simple-webserver = {
      wantedBy = [ "multi-user.target" ];
      script = ''
        cd /etc/webroot
        ${pkgs.python3}/bin/python -m http.server 80
      '';
    };
  };
  copyCert = src: dest: filename: ''
    from shlex import quote
    ${src}.wait_for_file("/test-key-and-cert.pem")
    server_cert = ${src}.succeed("cat /test-cert.pem")
    ${dest}.succeed("echo %s > ${filename}" % quote(server_cert))
  '';

in {
  basicServer = makeTest {
    name = "basicServer";

    nodes = {
      client = { };
      server = {
        imports = [ makeCert serverCommon stunnelCommon ];
        environment.etc."webroot/index.html".text = "well met";
      };
    };

    testScript = ''
      start_all()

      ${copyCert "server" "client" "/authorized-server-cert.crt"}

      server.wait_for_unit("simple-webserver")
      server.wait_for_unit("stunnel")

      client.succeed("curl --fail --cacert /authorized-server-cert.crt https://server/ > out")
      client.succeed('[[ "$(< out)" == "well met" ]]')
    '';
  };

  serverAndClient = makeTest {
    name = "serverAndClient";

    nodes = {
      client = {
        imports = [ stunnelCommon ];
        services.stunnel.clients = {
          httpsClient = {
            accept = "80";
            connect = "server:443";
            CAFile = "/authorized-server-cert.crt";
          };
          httpsClientWithHostVerify = {
            accept = "81";
            connect = "server:443";
            CAFile = "/authorized-server-cert.crt";
            verifyHostname = "server";
          };
          httpsClientWithHostVerifyFail = {
            accept = "82";
            connect = "server:443";
            CAFile = "/authorized-server-cert.crt";
            verifyHostname = "wronghostname";
          };
        };
      };
      server = {
        imports = [ makeCert serverCommon stunnelCommon ];
        environment.etc."webroot/index.html".text = "hello there";
      };
    };

    testScript = ''
      start_all()

      ${copyCert "server" "client" "/authorized-server-cert.crt"}

      server.wait_for_unit("simple-webserver")
      server.wait_for_unit("stunnel")

      # In case stunnel came up before we got the server's cert copied over
      client.succeed("systemctl reload-or-restart stunnel")

      client.succeed("curl --fail http://localhost/ > out")
      client.succeed('[[ "$(< out)" == "hello there" ]]')

      client.succeed("curl --fail http://localhost:81/ > out")
      client.succeed('[[ "$(< out)" == "hello there" ]]')

      client.fail("curl --fail http://localhost:82/ > out")
      client.succeed('[[ "$(< out)" == "" ]]')
    '';
  };

  mutualAuth = makeTest {
    name = "mutualAuth";

    nodes = rec {
      client = {
        imports = [ makeCert stunnelCommon ];
        services.stunnel.clients.authenticated-https = {
          accept = "80";
          connect = "server:443";
          verifyPeer = true;
          CAFile = "/authorized-server-cert.crt";
          cert = "/test-cert.pem";
          key = "/test-key.pem";
        };
      };
      wrongclient = client;
      server = {
        imports = [ makeCert serverCommon stunnelCommon ];
        services.stunnel.servers.https = {
          CAFile = "/authorized-client-certs.crt";
          verifyPeer = true;
        };
        environment.etc."webroot/index.html".text = "secret handshake";
      };
    };

    testScript = ''
      start_all()

      ${copyCert "server" "client" "/authorized-server-cert.crt"}
      ${copyCert "client" "server" "/authorized-client-certs.crt"}
      ${copyCert "server" "wrongclient" "/authorized-server-cert.crt"}

      # In case stunnel came up before we got the cross-certs in place
      client.succeed("systemctl reload-or-restart stunnel")
      server.succeed("systemctl reload-or-restart stunnel")
      wrongclient.succeed("systemctl reload-or-restart stunnel")

      server.wait_for_unit("simple-webserver")
      client.fail("curl --fail --insecure https://server/ > out")
      client.succeed('[[ "$(< out)" == "" ]]')
      client.succeed("curl --fail http://localhost/ > out")
      client.succeed('[[ "$(< out)" == "secret handshake" ]]')
      wrongclient.fail("curl --fail http://localhost/ > out")
      wrongclient.succeed('[[ "$(< out)" == "" ]]')
    '';
  };
}
