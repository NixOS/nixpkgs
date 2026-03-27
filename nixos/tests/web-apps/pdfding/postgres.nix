{
  lib,
  pkgs,
  ...
}:
{
  name = "PdfDing postgres";

  nodes = {
    machine =
      { config, ... }:
      {
        # WARNING: Do not add secrets to the world-readable /nix/store in a production deployment
        # Use a secret management scheme instead https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes
        services.pdfding = {
          enable = true;
          secretKeyFile = pkgs.writeText "secretKeyFile" "test123";
          database.createLocally = true;
          database.type = "postgres";
          consume.enable = true; # allows bulk importing pdf files from the backend
          consume.schedule = "*/1 * * * *"; # once every minute
          installTestHelpers = true;
        };

        environment.systemPackages = [
          config.services.postgresql.finalPackage
        ];
      };
  };

  # Tests the most basic user functionality expected from pdfding with postgres and consume feature
  testScript =
    { nodes, ... }:
    let
      stateDir = "/var/lib/pdfding";
    in
    # py
    ''
      # start
      start_all()

      # create admin
      machine.wait_for_unit("multi-user.target")

      machine.succeed("DJANGO_SUPERUSER_PASSWORD=admin pdfding-manage createsuperuser --no-input --username admin --email admin@localhost")

      test_pdf = "${pkgs.pdfding.src}/pdfding/pdf/tests/data/dummy.pdf"

      # copy to consume dir
      machine.succeed(f"sudo -u pdfding bash -c 'mkdir -p ${stateDir}/consume/1 && cp {test_pdf} ${stateDir}/consume/1/'")

      # check the file was copied
      output = machine.succeed("sudo -u pdfding bash -c 'ls -l ${stateDir}/consume/1/'")
      assert "dummy.pdf" in output, "dummy pdf file not found"

      # check there are no pdfs
      machine.succeed("sudo -u pdfding psql -tAc 'SELECT COUNT(*) FROM pdf_pdf' | grep -q '^0$'")

      print(machine.succeed("realpath /run/current-system/sw/bin/consume-immediate"))
      print(machine.succeed("consume-immediate"))

      # verify pdf is in user's dir, and removed from consume dir
      machine.wait_for_file("${stateDir}/media/1/default/pdf/dummy.pdf")
      machine.fail("test -f ${stateDir}/consume/1/default/pdf/dummy.pdf")

      # verify pdf is also in postgres db
      machine.succeed("sudo -u pdfding psql -tAc 'SELECT COUNT(*) FROM pdf_pdf' | grep -q '^1$'")
    '';

  # Debug interactively with:
  # - nix run .#nixosTests.pdfding.postgres.driverInteractive -L
  # - start_all() / run_tests()
  interactive.sshBackdoor.enable = true; # ssh -o User=root vsock%3
  interactive.nodes.machine =
    { config, ... }:
    let
      port = config.services.pdfding.port;
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
      }) [ port ];

      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = [ port ];
    };

  meta.maintainers = lib.teams.ngi.members;
}
