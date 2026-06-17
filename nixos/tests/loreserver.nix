{ pkgs, lib, ... }:

let
  # Quick'n'dirty CA just for testing purposes.
  testCerts =
    pkgs.runCommand "lore-test-certs"
      {
        nativeBuildInputs = [ pkgs.openssl ];
      }
      ''
        mkdir -p "$out"
        openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
          -keyout "$out/ca.key" -out "$out/ca.crt" -subj "/CN=Lore Test CA"
        openssl req -newkey rsa:2048 -nodes \
          -keyout "$out/server.key" -out server.csr -subj "/CN=tlsserver"
        printf 'subjectAltName=DNS:tlsserver,DNS:localhost,IP:127.0.0.1\n' > san.ext
        openssl x509 -req -in server.csr -CA "$out/ca.crt" -CAkey "$out/ca.key" \
          -CAcreateserial -days 3650 -extfile san.ext -out "$out/server.crt"
      '';
in
{
  name = "loreserver";
  meta.maintainers = [ lib.maintainers.jchw ];

  nodes.server = {
    services.loreserver = {
      enable = true;
      openFirewall = true;
      settings = {
        immutable_store.local.flush_delay_seconds = 1;
        mutable_store.local.flush_delay_seconds = 1;
        telemetry.logger.format = "text";
      };
    };

    environment.systemPackages = [
      pkgs.lore
      pkgs.curl
    ];

    virtualisation.memorySize = 3072;
    virtualisation.cores = 2;
  };

  nodes.client = {
    environment.systemPackages = [
      pkgs.lore
      pkgs.curl
    ];

    # Disable IPv6; Happy Eyeballs isn't doing what it is supposed to.
    networking.enableIPv6 = false;

    # Trust the test CA so the client can verify tlsserver's cert over lores://.
    security.pki.certificateFiles = [ "${testCerts}/ca.crt" ];
    virtualisation.memorySize = 1024;
  };

  # Node running a loreserver that uses TLS for QUIC and gRPC.
  nodes.tlsserver = {
    services.loreserver = {
      enable = true;
      openFirewall = true;
      settings = {
        immutable_store.local.flush_delay_seconds = 1;
        mutable_store.local.flush_delay_seconds = 1;
        telemetry.logger.format = "text";
        server.quic.certificate = {
          cert_file = "${testCerts}/server.crt";
          pkey_file = "${testCerts}/server.key";
        };
        server.grpc.certificate = {
          cert_file = "${testCerts}/server.crt";
          pkey_file = "${testCerts}/server.key";
        };
      };
    };

    virtualisation.memorySize = 2048;
    virtualisation.cores = 2;
  };

  # Node running a loreserver using JWT authentication.
  nodes.authserver = {
    services.nginx = {
      enable = true;
      virtualHosts.jwks = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 8080;
          }
        ];
        # This is enough for our test.
        locations."= /jwks.json".extraConfig = ''
          default_type application/json;
          return 200 '{"keys":[]}';
        '';
      };
    };

    services.loreserver = {
      enable = true;
      settings = {
        immutable_store.local.flush_delay_seconds = 1;
        mutable_store.local.flush_delay_seconds = 1;
        telemetry.logger.format = "text";
        server.auth.jwk.endpoint = "http://127.0.0.1:8080/jwks.json";
      };
    };

    # The server fetches the JWKS at startup, so it must come up after nginx.
    systemd.services.loreserver = {
      after = [ "nginx.service" ];
      wants = [ "nginx.service" ];
    };

    environment.systemPackages = [
      pkgs.lore
      pkgs.curl
    ];
    virtualisation.memorySize = 2048;
    virtualisation.cores = 2;
  };

  testScript = ''
    start_all()

    with subtest("server starts and reports healthy"):
        client.wait_for_unit("multi-user.target")
        server.wait_for_unit("loreserver.service")
        server.wait_for_open_port(41337)
        server.wait_for_open_port(41339)
        server.wait_until_succeeds(
            "curl -fsS -o /dev/null -w '%{http_code}' http://127.0.0.1:41339/health_check | grep -qx 200",
            timeout=60,
        )

    with subtest("module-managed self-signed certificate is persisted"):
        server.succeed("test -s /var/lib/loreserver/certs/cert.pem")
        server.succeed("test -s /var/lib/loreserver/certs/key.pem")

    with subtest("create a repository, stage, commit and push"):
        server.succeed("mkdir -p /root/my-project")
        server.succeed(
            "cd /root/my-project && lore repository create lore://127.0.0.1:41337/my-project"
        )
        server.succeed("test -d /root/my-project/.lore")
        server.succeed("echo 'Hello, Lore' > /root/my-project/hello.txt")
        # Woah, binary files!
        server.succeed("head -c 256 /dev/urandom > /root/my-project/sample.bin")
        server.succeed("cd /root/my-project && lore stage hello.txt sample.bin")
        server.succeed("cd /root/my-project && lore status --scan")
        server.succeed("cd /root/my-project && lore commit 'Initial revision'")
        server.succeed("cd /root/my-project && lore push")

    with subtest("clone into a second working tree"):
        server.succeed("cd /root && lore clone lore://127.0.0.1:41337/my-project my-project-b")
        server.succeed("test -f /root/my-project-b/hello.txt")
        server.succeed("test -f /root/my-project-b/sample.bin")
        server.succeed("grep -q 'Hello, Lore' /root/my-project-b/hello.txt")

    with subtest("branch, commit, merge into main and push"):
        server.succeed("cd /root/my-project && lore branch create my-first-branch")
        server.succeed("echo 'Notes added on a branch.' > /root/my-project/notes.txt")
        server.succeed("cd /root/my-project && lore stage notes.txt")
        server.succeed("cd /root/my-project && lore commit 'Add notes on a branch'")
        server.succeed("cd /root/my-project && lore branch switch main")
        server.succeed("test ! -e /root/my-project/notes.txt")
        server.succeed(
            "cd /root/my-project && lore branch merge my-first-branch "
            "--message 'Merge my-first-branch into main'"
        )
        server.succeed("test -f /root/my-project/notes.txt")
        server.succeed("cd /root/my-project && lore push")

    with subtest("sync the merged revision into the clone"):
        server.succeed("cd /root/my-project-b && lore sync")
        server.succeed("test -f /root/my-project-b/notes.txt")
        server.succeed("grep -q 'Notes added on a branch.' /root/my-project-b/notes.txt")

    with subtest("server survives a restart with the store intact"):
        server.systemctl("restart loreserver.service")
        server.wait_until_succeeds(
            "curl -fsS -o /dev/null -w '%{http_code}' http://127.0.0.1:41339/health_check | grep -qx 200",
            timeout=60,
        )
        server.succeed("cd /root && rm -rf verify && lore clone lore://127.0.0.1:41337/my-project verify")
        server.succeed("test -f /root/verify/notes.txt")

    with subtest("remote client reaches the server over the network"):
        client.wait_until_succeeds(
            "curl -fsS -o /dev/null -w '%{http_code}' http://server:41339/health_check | grep -qx 200",
            timeout=60,
        )
        client.succeed("cd /root && lore clone lore://server:41337/my-project remote-clone")
        client.succeed("test -f /root/remote-clone/notes.txt")
        client.succeed("grep -q 'Notes added on a branch.' /root/remote-clone/notes.txt")

    with subtest("remote client can create and push a new repository"):
        client.succeed("mkdir -p /root/remoteproject")
        client.succeed("cd /root/remoteproject && lore repository create lore://server:41337/remoteproject")
        client.succeed("echo 'from the client node' > /root/remoteproject/remote.txt")
        client.succeed("cd /root/remoteproject && lore stage remote.txt")
        client.succeed("cd /root/remoteproject && lore commit 'Remote client commit'")
        client.succeed("cd /root/remoteproject && lore push")
        server.succeed("cd /root && rm -rf remoteproject-check && lore clone lore://127.0.0.1:41337/remoteproject remoteproject-check")
        server.succeed("grep -q 'from the client node' /root/remoteproject-check/remote.txt")

    with subtest("verifies TLS when using custom CA certificate"):
        tlsserver.wait_for_unit("loreserver.service")
        tlsserver.wait_for_open_port(41337)
        tlsserver.wait_for_open_port(41339)
        tlsserver.succeed("test ! -e /var/lib/loreserver/certs/cert.pem")
        client.succeed("mkdir -p /root/secureproject")
        client.succeed("cd /root/secureproject && lore repository create lores://tlsserver:41337/secureproject")
        client.succeed("echo 'over verified TLS' > /root/secureproject/secure.txt")
        client.succeed("cd /root/secureproject && lore stage secure.txt")
        client.succeed("cd /root/secureproject && lore commit 'Secure commit'")
        client.succeed("cd /root/secureproject && lore push")
        client.succeed("cd /root && lore clone lores://tlsserver:41337/secureproject secureproject-clone")
        client.succeed("grep -q 'over verified TLS' /root/secureproject-clone/secure.txt")

    with subtest("rejects unauthenticated clients when using JWT"):
        authserver.wait_for_unit("nginx.service")
        authserver.wait_for_unit("loreserver.service")
        authserver.wait_for_open_port(41337)
        authserver.wait_until_succeeds(
            "curl -fsS -o /dev/null -w '%{http_code}' http://127.0.0.1:41339/health_check | grep -qx 200",
            timeout=60,
        )
        authserver.succeed("mkdir -p /root/jwtproject")
        out = authserver.fail(
            "cd /root/jwtproject && lore repository create lore://127.0.0.1:41337/jwtproject 2>&1"
        )
        assert "authorization header required" in out.lower(), f"expected an auth-related rejection, got:\n{out}"
  '';
}
