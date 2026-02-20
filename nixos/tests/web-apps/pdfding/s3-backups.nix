{
  lib,
  pkgs,
  ...
}:
let
  # WARNING: Do not add secrets to the world-readable /nix/store in a production deployment
  # Use a secret management scheme instead https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes

  # note: In a production deployment use `garage key generate`, along with the steps specified in the getting started guide of garage.
  # (sops-nix or agenix for configuring secrets for garage is out of scope here)
  garageAccessKey = "GK0a0a0a0b0b0b0c0c0c0d0d0d";
  garageSecretKey = "0a0a0a0a0b0b0b0b0c0c0c0c0d0d0d0d1a1a1a1a1b1b1b1b1c1c1c1c1d1d1d1d";
  pdfding-s3-keys = pkgs.writeText "pdfding-s3-keys" ''
    BACKUP_ACCESS_KEY=${garageAccessKey}
    BACKUP_SECRET_KEY=${garageSecretKey}
  '';
in
{
  name = "PdfDing s3 backups";

  nodes = {
    machine =
      { config, ... }:
      {
        services.pdfding = {
          enable = true;
          secretKeyFile = pkgs.writeText "secretKeyFile" "test123";

          backup.enable = true;
          backup.schedule = "*/1 * * * *";
          backup.endpoint = "[::]:3900";
          extraEnvironment.BACKUP_BUCKET_NAME = "pdfding-bucket";
          extraEnvironment.BACKUP_REGION = "garage";

          envFiles = [ pdfding-s3-keys ];
          installTestHelpers = true;
        };

        # Setup a local garage service for the backup feature
        # taken from garage nixosTest
        services.garage = {
          enable = true;
          package = pkgs.garage_2;
          settings = {
            rpc_bind_addr = "[::]:3901";
            rpc_public_addr = "[::1]:3901";
            rpc_secret = "5c1915fa04d0b6739675c61bf5907eb0fe3d9c69850c83820f51b4d25d13868c";

            s3_api = {
              s3_region = "garage";
              api_bind_addr = "[::]:3900";
              root_domain = ".s3.garage";
            };

            s3_web = {
              bind_addr = "[::]:3902";
              root_domain = ".web.garage";
              index = "index.html";
            };

            replication_factor = 1;
          };
        };

        # setup garage bucket and credentials
        # note: The nixos module has no option to specify secrets declaratively
        systemd.services.garage.postStart = ''
          export PATH="$PATH:${config.services.garage.package}/bin"

          # wait for garage to be up
          while ! garage status >/dev/null 2>&1; do sleep 2; done

          if ! garage bucket list | grep -q pdfding-bucket; then
            garage layout assign -z dc1 -c 1G $(garage status | cut -d' ' -f1 | tail -1)
            garage layout apply --version 1

            # note: the key id should be valid (starts with `GK`, followed by 12 hex-encoded bytes)
            #       the secret key should be valid (composed of 32 hex-encoded bytes)
            garage key import ${garageAccessKey} ${garageSecretKey} -n pdfding-key --yes

            garage bucket create pdfding-bucket

            garage bucket allow --read --write --owner pdfding-bucket --key pdfding-key
          fi
        '';

        # Garage requires at least 1GiB of free disk space to run.
        virtualisation.diskSize = 2 * 1024;

        environment.systemPackages = with pkgs; [
          minio-client
          sqlite
        ];
      };
  };

  # Tests the most basic user functionality expected from pdfding backup service
  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.services.pdfding) port;
      stateDir = "/var/lib/pdfding";
    in
    # py
    ''
      # start vms
      start_all()

      # create admin
      machine.wait_for_unit("multi-user.target")
      machine.succeed("DJANGO_SUPERUSER_PASSWORD=admin pdfding-manage createsuperuser --no-input --username admin --email admin@localhost")

      # login
      endpoint = "http://localhost:${toString port}"
      cookie_jar = "/tmp/cookies.txt"
      machine.succeed(f"""
        curl -f \
          -X POST -c {cookie_jar} -b {cookie_jar} \
          -d "csrfmiddlewaretoken=$(curl -f -c {cookie_jar} -s '{endpoint}/accountlogin/' | grep -oP 'name="csrfmiddlewaretoken" value="\\K[^"]+')" \
          -d "login=admin@localhost" \
          -d "password=admin" \
          {endpoint}/accountlogin/
      """)

      test_pdf = "${pkgs.pdfding.src}/pdfding/pdf/tests/data/dummy.pdf"

      # upload
      machine.succeed(f"""
        csrf_token=$(curl -f -b {cookie_jar} -c {cookie_jar} -s "{endpoint}/pdf/add" | grep -oP 'name="csrfmiddlewaretoken" value="\\K[^"]+')
        curl -f \
          -c {cookie_jar} -b {cookie_jar} \
          -F "notes=" \
          -F "tag_string=" \
          -F "description=" \
          -F "collection=1" \
          -F "use_file_name=on" \
          -F "name=test-upload" \
          -F "file=@{test_pdf};type=application/pdf" \
          -F "csrfmiddlewaretoken=$csrf_token" \
          -H "Referer: {endpoint}/pdf/add" \
          {endpoint}/pdf/add
      """)

      # download
      machine.succeed(f"""
        pdf_id=$(curl -f -b {cookie_jar} -s "{endpoint}/pdf/" | grep -oP 'href="/pdf/view/\\K[^"]+' | head -1)
        curl -f -b {cookie_jar} -o /tmp/downloaded.pdf "{endpoint}/pdf/download/$pdf_id"
      """)

      # verify pdf in user's dir
      machine.succeed("test -f ${stateDir}/media/1/default/pdf/*.pdf")

      # verify one entry exists in sqlite db
      machine.succeed("sqlite3 ${stateDir}/db/db.sqlite3 'SELECT COUNT(*) FROM pdf_pdf' | grep -q '^1$'")

      machine.succeed("""
        source ${pdfding-s3-keys}
        mc alias set garage --api S3v4 \
          http://[::]:3900 $BACKUP_ACCESS_KEY $BACKUP_SECRET_KEY
      """)

      print(machine.succeed("realpath /run/current-system/sw/bin/backup-immediate"))
      print(machine.succeed("backup-immediate"))

      # verify the backup s3 service has that pdf file
      machine.wait_until_succeeds("mc stat garage/pdfding-bucket/1/default/pdf/dummy.pdf", timeout=10)
      print(machine.succeed("mc stat garage/pdfding-bucket/1/default/pdf/dummy.pdf"))
    '';

  # Debug interactively with:
  # - nix run .#nixosTests.pdfding.s3.driverInteractive -L
  # - start_all() / run_tests()
  interactive.sshBackdoor.enable = true; # ssh -o User=root vsock%3
  interactive.nodes.machine =
    { config, ... }:
    let
      ports = [
        config.services.pdfding.port
        3901
        3902
      ];
    in
    {
      # not needed, only for manual interactive debugging
      virtualisation.memorySize = 4096;
      environment.systemPackages = with pkgs; [
        htop
      ];

      virtualisation.forwardPorts = map (port: {
        from = "host";
        host.port = port;
        guest.port = port;
      }) ports;

      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = ports;
    };

  meta.maintainers = lib.teams.ngi.members;
}
