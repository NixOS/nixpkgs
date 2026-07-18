# End-to-end NixOS VM test for the proxmox-backup-server module.
#
# Boots a PBS server with every module feature enabled (declarative datastore +
# prune/verify jobs, custom TLS cert) and drives a real backup -> restore ->
# verify -> garbage-collect cycle with proxmox-backup-client.
{ pkgs, lib, ... }:

let
  rootPassword = "test-password";

  # Throwaway TLS cert/key for exercising services.proxmox-backup-server.ssl*.
  testCert =
    pkgs.runCommand "pbs-test-cert"
      {
        nativeBuildInputs = [ pkgs.openssl ];
      }
      ''
        mkdir -p $out
        openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
          -keyout $out/key.pem -out $out/cert.pem -subj "/CN=pbs-test.local"
      '';
in
{
  name = "proxmox-backup-server";
  meta.maintainers = with lib.maintainers; [ awildleon ];

  node.pkgsReadOnly = false;

  nodes.machine =
    { pkgs, lib, ... }:
    {
      virtualisation.memorySize = 2048;
      virtualisation.cores = 4;
      virtualisation.diskSize = 4096;

      # The test framework sets an empty root hashedPasswordFile (mkOverride 150),
      # which would win over `password` and break root@pam auth. Clear it so our
      # password is the effective one.
      users.users.root.hashedPasswordFile = lib.mkForce null;
      users.users.root.password = rootPassword;

      environment.systemPackages = [
        pkgs.proxmox-backup-client
        pkgs.openssl
        pkgs.jq
      ];

      services.proxmox-backup-server = {
        enable = true;
        openFirewall = true;

        sslCertificate = "${testCert}/cert.pem";
        sslCertificateKey = "${testCert}/key.pem";

        ensureDatastores.main = {
          path = "/var/lib/proxmox-backup/datastores/main";
          comment = "Test store";
          gcSchedule = "daily";
        };
        ensurePruneJobs.main-prune = {
          datastore = "main";
          schedule = "daily";
          settings = {
            keep-daily = 7;
            keep-weekly = 4;
          };
        };
        ensureVerifyJobs.main-verify = {
          datastore = "main";
          schedule = "sun 02:00";
        };
      };
    };

  testScript = ''
    root_password = "${rootPassword}"

    machine.start()

    # Daemons up and declarative reconcile finished (oneshot + RemainAfterExit).
    machine.wait_for_unit("proxmox-backup.service")
    machine.wait_for_unit("proxmox-backup-proxy.service")
    machine.wait_for_unit("proxmox-backup-setup.service")
    machine.wait_for_open_port(8007)

    with subtest("declarative datastore was created"):
        machine.succeed("proxmox-backup-manager datastore list | grep -w main")
        machine.succeed("test -d /var/lib/proxmox-backup/datastores/main/.chunks")

    with subtest("declarative jobs were created"):
        machine.succeed("proxmox-backup-manager prune-job list | grep -w main-prune")
        machine.succeed("proxmox-backup-manager verify-job list | grep -w main-verify")

    with subtest("custom TLS certificate is served"):
        subject = machine.succeed(
            "echo | openssl s_client -connect localhost:8007 2>/dev/null "
            "| openssl x509 -noout -subject"
        )
        assert "pbs-test.local" in subject, f"unexpected cert subject: {subject!r}"

    with subtest("backup, restore, verify and GC round-trip"):
        machine.succeed("mkdir -p /root/data")
        machine.succeed("echo hello-pbs > /root/data/hello.txt")

        # The client pins the served cert by fingerprint; take PBS's own
        # canonical value so the format matches exactly.
        fp = machine.succeed(
            "proxmox-backup-manager cert info | sed -n 's/.*Fingerprint (sha256): //p'"
        ).strip()

        env = (
            f"PBS_PASSWORD={root_password!r} "
            f"PBS_FINGERPRINT={fp!r} "
            "PBS_REPOSITORY=root@pam@localhost:main"
        )

        machine.succeed(f"cd /root && {env} proxmox-backup-client backup data.pxar:/root/data")

        snapshots = machine.succeed(
            f"{env} proxmox-backup-client snapshot list --output-format json"
        )
        import json, datetime
        snap = json.loads(snapshots)[0]
        # JSON gives backup-time as an epoch int, but the restore CLI parses the
        # snapshot time as RFC3339 (UTC, 'Z'), so convert it.
        ts = datetime.datetime.fromtimestamp(
            snap["backup-time"], datetime.timezone.utc
        ).strftime("%Y-%m-%dT%H:%M:%SZ")
        snapshot = f"{snap['backup-type']}/{snap['backup-id']}/{ts}"

        machine.succeed(
            f"{env} proxmox-backup-client restore {snapshot} data.pxar /root/restore"
        )
        machine.succeed("grep -q hello-pbs /root/restore/hello.txt")

        machine.succeed("proxmox-backup-manager verify main")
        machine.succeed("proxmox-backup-manager garbage-collection start main")
  '';
}
