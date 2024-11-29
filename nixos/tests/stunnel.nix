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
    systemd.services.create-test-cert = {
      wantedBy = [ "sysinit.target" ];
      before = [ "sysinit.target" "shutdown.target" ];
      conflicts = [ "shutdown.target" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.openssl}/bin/openssl req -batch -x509 -newkey rsa -nodes -out /test-cert.pem -keyout /test-key.pem -subj /CN=${config.networking.hostName}
        ( umask 077; cat /test-key.pem /test-cert.pem > /test-key-and-cert.pem )
        chown stunnel /test-key.pem /test-key-and-cert.pem
    '';
    };
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
  copyThisCert = waitfile: serverfile: src: dest: filename: ''
    from shlex import quote
    ${src}.wait_for_file("${waitfile}")
    server_cert = ${src}.succeed("cat ${serverfile}")
    ${dest}.succeed("echo %s > ${filename}" % quote(server_cert))
  '';
  copyCert = copyThisCert "/test-key-and-cert.pem" "/test-cert.pem";

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

  sni = makeTest {
    name = "sni";

    nodes = {
      client = { environment.systemPackages = with pkgs; [ openssl ]; };
      server = {
        imports = [ makeCert serverCommon stunnelCommon ];
        environment.etc."webroot/index.html".text = "Christine!";
        services.stunnel.servers.phantom = {
          sni = "https:phantom";
          connect = 80;
          cert = "/phantom-key-and-cert.pem";
        };
      system.activationScripts.create-phantom-cert = stringAfter [ "users" ] ''
        ${pkgs.openssl}/bin/openssl req -batch -x509 -newkey rsa -nodes -out /phantom-cert.pem -keyout /phantom-key.pem -subj /CN=phantom
        ( umask 077; cat /phantom-key.pem /phantom-cert.pem > /phantom-key-and-cert.pem )
        chown stunnel /phantom-key.pem /phantom-key-and-cert.pem
      '';
      };
    };

    testScript = ''
      start_all()

      ${copyThisCert "/test-key-and-cert.pem" "/test-cert.pem" "server" "client" "/authorized-server-cert.crt"}
      ${copyThisCert "/phantom-key-and-cert.pem" "/phantom-cert.pem" "server" "client" "/phantom-server-cert.crt"}
      client.succeed("cat /authorized-server-cert.crt /phantom-server-cert.crt > /both-server-certs.crt")

      server.wait_for_unit("simple-webserver")
      server.wait_for_unit("stunnel")

      client.succeed("curl --fail --cacert /both-server-certs.crt https://server/ > out")
      client.succeed('[[ "$(< out)" == "Christine!" ]]')

      client.succeed("curl --fail --cacert /both-server-certs.crt --connect-to phantom:443:server:443 https://phantom/ > pout")
      client.succeed('[[ "$(< pout)" == "Christine!" ]]')

      client.succeed("openssl s_client -connect server:443 < /dev/null > tls-info-0 2>&1")
      client.succeed("openssl s_client -connect server:443 -servername server < /dev/null > tls-info-server 2>&1")
      client.succeed("openssl s_client -connect server:443 -servername phantom < /dev/null > tls-info-phantom 2>&1")

      client.succeed("grep 'CN = server' tls-info-0")
      client.succeed("grep 'CN = server' tls-info-server")
      client.fail("grep 'CN = server' tls-info-phantom")

      client.fail("grep 'CN = phantom' tls-info-0")
      client.fail("grep 'CN = phantom' tls-info-server")
      client.succeed("grep 'CN = phantom' tls-info-phantom")
    '';
  };

}
