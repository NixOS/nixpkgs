import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "gns3-server";
    meta.maintainers = [ lib.maintainers.anthonyroussel ];

    nodes.machine =
      { ... }:
      let
        tls-cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
          openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -days 365 \
            -subj '/CN=localhost'
          install -D -t $out key.pem cert.pem
        '';
      in
      {
        services.gns3-server = {
          enable = true;
          auth = {
            enable = true;
            user = "user";
            passwordFile = pkgs.writeText "gns3-auth-password-file" "password";
          };
          ssl = {
            enable = true;
            certFile = "${tls-cert}/cert.pem";
            keyFile = "${tls-cert}/key.pem";
          };
          dynamips.enable = true;
          ubridge.enable = true;
          vpcs.enable = true;
        };

        security.pki.certificateFiles = [ "${tls-cert}/cert.pem" ];
      };

    testScript =
      let
        createProject = pkgs.writeText "createProject.json" (
          builtins.toJSON {
            name = "test_project";
          }
        );
      in
      ''
        start_all()

        machine.wait_for_unit("gns3-server.service")
        machine.wait_for_open_port(3080)

        with subtest("server is listening"):
          machine.succeed("curl -sSfL -u user:password https://localhost:3080/v2/version")

        with subtest("create dummy project"):
          machine.succeed("curl -sSfL -u user:password https://localhost:3080/v2/projects -d @${createProject}")

        with subtest("logging works"):
          log_path = "/var/log/gns3/server.log"
          machine.wait_for_file(log_path)
      '';
  }
)
