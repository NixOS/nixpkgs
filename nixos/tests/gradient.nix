{ lib, pkgs, ... }:
let
  secret = name: text: toString (pkgs.writeText name text);

  repositories = pkgs.runCommand "gradient-test-repositories" { nativeBuildInputs = [ pkgs.git ]; } ''
    git init -q -b main $out/test
    cd $out/test
    cat > flake.nix <<'EOF'
    {
      outputs = _: {
        packages.x86_64-linux.default = derivation {
          name = "gradient-test";
          system = "x86_64-linux";
          builder = "/bin/sh";
          args = [ "-c" "echo ok > $out" ];
        };
      };
    }
    EOF
    echo '{"nodes":{"root":{}},"root":"root","version":7}' > flake.lock
    git add .
    git -c user.name=test -c user.email=test@localhost commit -qm init
  '';
in
{
  name = "gradient";
  meta.teams = [ lib.teams.gradient ];

  nodes.machine = {
    virtualisation.memorySize = 4096;

    programs.git = {
      enable = true;
      config.safe.directory = "*";
    };

    services.gitDaemon = {
      enable = true;
      basePath = "${repositories}";
      exportAll = true;
    };

    services.gradient = {
      enable = true;
      domain = "localhost";
      postgres.enable = true;
      worker.enable = true;
      environmentVariables.GRADIENT_USE_TLS = false;

      secrets = {
        jwtFile = secret "jwt" "b68a8eaa8ebcff23ebaba1bd74ecb8a2eb7ba959570ff8842f148207524c7b8d";
        cryptFile = secret "crypt" "aW52YWxpZC1pbnZhbGlkLWludmFsaWQK";
      };

      state = {
        users.admin.email = "admin@example.com";

        projects.project = {
          created_by = "admin";
          private_key_file = secret "ssh-key" ''
            -----BEGIN OPENSSH PRIVATE KEY-----
            b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
            QyNTUxOQAAACDle/PUDDuuI9h8+ViFyHMQjqARSRhLJcYKnay7MrflOgAAAJALQNCyC0DQ
            sgAAAAtzc2gtZWQyNTUxOQAAACDle/PUDDuuI9h8+ViFyHMQjqARSRhLJcYKnay7MrflOg
            AAAEAROowXB/e8+691yZgfHOASTPVyIM2Hx7U9RpmAtUda++V789QMO64j2Hz5WIXIcxCO
            oBFJGEslxgqdrLsyt+U6AAAABm5vbmFtZQECAwQFBgc=
            -----END OPENSSH PRIVATE KEY-----
          '';
        };

        tasks.task = {
          project = "project";
          repository = "git://localhost/test";
          wildcard = "packages.x86_64-linux.*";
          created_by = "admin";
          triggers = [
            {
              type = "polling";
              config.interval_secs = 10;
            }
          ];
        };

        caches.main = {
          signing_key_file = secret "cache-key" "22yRW7p/hxuPRWJh9pcfGH0oXPk2MFUuG0wIA1rfq1BvDbvMqzMZS+er/BE8ucbxNSG5KZ8B0ELO4TJal8mZlw==";
          projects = [ "project" ];
          upstream_caches = [ ];
          created_by = "admin";
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("gradient-server.service")
    machine.wait_until_succeeds(
        "runuser -u postgres -- psql -d gradient -Atc 'SELECT status FROM evaluation' | grep -qx 5",
        timeout=900,
    )
  '';
}
