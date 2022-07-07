/*
  This test runs podman as a backend for the Docker CLI.
 */
import ../make-test-python.nix (
  { pkgs, lib, ... }:

  let gen-ca = pkgs.writeScript "gen-ca" ''
    # Create CA
    PATH="${pkgs.openssl}/bin:$PATH"
    openssl genrsa -out ca-key.pem 4096
    openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -subj '/C=NL/ST=Zuid-Holland/L=The Hague/O=Stevige Balken en Planken B.V./OU=OpSec/CN=Certificate Authority' -out ca.pem

    # Create service
    openssl genrsa -out podman-key.pem 4096
    openssl req -subj '/CN=podman' -sha256 -new -key podman-key.pem -out service.csr
    echo subjectAltName = DNS:podman,IP:127.0.0.1 >> extfile.cnf
    echo extendedKeyUsage = serverAuth >> extfile.cnf
    openssl x509 -req -days 365 -sha256 -in service.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out podman-cert.pem -extfile extfile.cnf

    # Create client
    openssl genrsa -out client-key.pem 4096
    openssl req -subj '/CN=client' -new -key client-key.pem -out client.csr
    echo extendedKeyUsage = clientAuth > extfile-client.cnf
    openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -extfile extfile-client.cnf

    # Create CA 2
    PATH="${pkgs.openssl}/bin:$PATH"
    openssl genrsa -out ca-2-key.pem 4096
    openssl req -new -x509 -days 365 -key ca-2-key.pem -sha256 -subj '/C=NL/ST=Zuid-Holland/L=The Hague/O=Stevige Balken en Planken B.V./OU=OpSec/CN=Certificate Authority' -out ca-2.pem

    # Create client signed by CA 2
    openssl genrsa -out client-2-key.pem 4096
    openssl req -subj '/CN=client' -new -key client-2-key.pem -out client-2.csr
    echo extendedKeyUsage = clientAuth > extfile-client.cnf
    openssl x509 -req -days 365 -sha256 -in client-2.csr -CA ca-2.pem -CAkey ca-2-key.pem -CAcreateserial -out client-2-cert.pem -extfile extfile-client.cnf

    '';
  in
  {
    name = "podman-tls-ghostunnel";
    meta = {
      maintainers = lib.teams.podman.members ++ [ lib.maintainers.roberth ];
    };

    nodes = {
      podman =
        { pkgs, ... }:
        {
          virtualisation.podman.enable = true;
          virtualisation.podman.dockerSocket.enable = true;
          virtualisation.podman.networkSocket = {
            enable = true;
            openFirewall = true;
            server = "ghostunnel";
            tls.cert = "/root/podman-cert.pem";
            tls.key = "/root/podman-key.pem";
            tls.cacert = "/root/ca.pem";
          };

          environment.systemPackages = [
            pkgs.docker-client
          ];

          users.users.alice = {
            isNormalUser = true;
            home = "/home/alice";
            description = "Alice Foobar";
            extraGroups = ["podman"];
          };

        };

      client = { ... }: {
        environment.systemPackages = [
          # Installs the docker _client_ only
          # Normally, you'd want `virtualisation.docker.enable = true;`.
          pkgs.docker-client
        ];
        environment.variables.DOCKER_HOST = "podman:2376";
        environment.variables.DOCKER_TLS_VERIFY = "1";
      };
    };

    testScript = ''
      import shlex


      def su_cmd(user, cmd):
          cmd = shlex.quote(cmd)
          return f"su {user} -l -c {cmd}"

      def cmd(command):
        print(f"+{command}")
        r = os.system(command)
        if r != 0:
          raise Exception(f"Command {command} failed with exit code {r}")

      start_all()
      cmd("${gen-ca}")

      podman.copy_from_host("ca.pem", "/root/ca.pem")
      podman.copy_from_host("podman-cert.pem", "/root/podman-cert.pem")
      podman.copy_from_host("podman-key.pem", "/root/podman-key.pem")

      client.copy_from_host("ca.pem", "/root/.docker/ca.pem")
      # client.copy_from_host("podman-cert.pem", "/root/podman-cert.pem")
      client.copy_from_host("client-cert.pem", "/root/.docker/cert.pem")
      client.copy_from_host("client-key.pem", "/root/.docker/key.pem")

      # TODO (ghostunnel): add file watchers so the restart isn't necessary
      podman.succeed("systemctl reset-failed && systemctl restart ghostunnel-server-podman-socket.service")

      podman.wait_for_unit("sockets.target")
      podman.wait_for_unit("ghostunnel-server-podman-socket.service")

      with subtest("Create default network"):
          podman.succeed("docker network create default")

      with subtest("Root docker cli also works"):
          podman.succeed("docker version")

      with subtest("A podman member can also still use the docker cli"):
          podman.succeed(su_cmd("alice", "docker version"))

      with subtest("Run container remotely via docker cli"):
          client.succeed("docker version")

          # via socket would be nicer
          podman.succeed("tar cv --files-from /dev/null | podman import - scratchimg")

          client.succeed(
            "docker run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin localhost/scratchimg /bin/sleep 10"
          )
          client.succeed("docker ps | grep sleeping")
          podman.succeed("docker ps | grep sleeping")
          client.succeed("docker stop sleeping")
          client.succeed("docker rm sleeping")

      with subtest("Clients without cert will be denied"):
          client.succeed("rm /root/.docker/{cert,key}.pem")
          client.fail("docker version")

      with subtest("Clients with wrong cert will be denied"):
          client.copy_from_host("client-2-cert.pem", "/root/.docker/cert.pem")
          client.copy_from_host("client-2-key.pem", "/root/.docker/key.pem")
          client.fail("docker version")

    '';
  }
)
