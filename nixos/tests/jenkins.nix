# verifies:
#   1. jenkins service starts on master node
#   2. jenkins user can be extended on both master and slave
#   3. jenkins service not started on slave node
#   4. declarative jobs can be added and removed

{ config, lib, ... }:
{
  name = "jenkins";
  meta = with lib.maintainers; {
    maintainers = [
      bjornfor
    ];
  };

  nodes = {

    master =
      { ... }:
      {
        services.jenkins = {
          enable = true;
          jobBuilder = {
            enable = true;
            nixJobs = [
              {
                job = {
                  name = "job-1";
                  builders = [
                    {
                      shell = ''
                        echo "Running job-1"
                      '';
                    }
                  ];
                };
              }

              {
                job = {
                  name = "folder-1";
                  project-type = "folder";
                };
              }

              {
                job = {
                  name = "folder-1/job-2";
                  builders = [
                    {
                      shell = ''
                        echo "Running job-2"
                      '';
                    }
                  ];
                };
              }
            ];
          };
        };

        specialisation.noJenkinsJobs.configuration = {
          services.jenkins.jobBuilder.nixJobs = lib.mkForce [ ];
        };

        # should have no effect
        services.jenkinsSlave.enable = true;

        users.users.jenkins.extraGroups = [ "users" ];

        systemd.services.jenkins.serviceConfig.TimeoutStartSec = "6min";

        # Increase disk space to prevent this issue:
        #
        # WARNING h.n.DiskSpaceMonitorDescriptor#markNodeOfflineOrOnline: Making Built-In Node offline temporarily due to the lack of disk space
        virtualisation.diskSize = 2 * 1024;
      };

    slave =
      { ... }:
      {
        services.jenkinsSlave.enable = true;

        users.users.jenkins.extraGroups = [ "users" ];
      };

  };

  testScript =
    { nodes, ... }:
    let
      pkgs = config.node.pkgs;
      configWithoutJobs = "${nodes.master.system.build.toplevel}/specialisation/noJenkinsJobs";
      jenkinsPort = nodes.master.services.jenkins.port;
      jenkinsUrl = "http://localhost:${toString jenkinsPort}";
    in
    ''
      start_all()

      master.wait_for_unit("default.target")

      assert "Authentication required" in master.succeed("curl http://localhost:8080")

      for host in master, slave:
          groups = host.succeed("sudo -u jenkins groups")
          assert "jenkins" in groups
          assert "users" in groups

      slave.fail("systemctl is-enabled jenkins.service")

      slave.succeed("java -fullversion")

      with subtest("jobs are declarative"):
          # Check that jobs are created on disk.
          master.wait_until_succeeds("test -f /var/lib/jenkins/jobs/job-1/config.xml")
          master.wait_until_succeeds("test -f /var/lib/jenkins/jobs/folder-1/config.xml")
          master.wait_until_succeeds("test -f /var/lib/jenkins/jobs/folder-1/jobs/job-2/config.xml")

          # Verify that jenkins also sees the jobs.
          out = master.succeed("${pkgs.jenkins}/bin/jenkins-cli -s ${jenkinsUrl} -auth admin:$(cat /var/lib/jenkins/secrets/initialAdminPassword) list-jobs")
          jobs = [x.strip() for x in out.splitlines()]
          # Seeing jobs inside folders requires the Folders plugin
          # (https://plugins.jenkins.io/cloudbees-folder/), which we don't have
          # in this vanilla jenkins install, so limit ourself to non-folder jobs.
          assert jobs == ['job-1'], f"jobs != ['job-1']: {jobs}"

          master.succeed(
              "${configWithoutJobs}/bin/switch-to-configuration test >&2"
          )

          # Check that jobs are removed from disk.
          master.wait_until_fails("test -f /var/lib/jenkins/jobs/job-1/config.xml")
          master.wait_until_fails("test -f /var/lib/jenkins/jobs/folder-1/config.xml")
          master.wait_until_fails("test -f /var/lib/jenkins/jobs/folder-1/jobs/job-2/config.xml")

          # Verify that jenkins also sees the jobs as removed.
          out = master.succeed("${pkgs.jenkins}/bin/jenkins-cli -s ${jenkinsUrl} -auth admin:$(cat /var/lib/jenkins/secrets/initialAdminPassword) list-jobs")
          jobs = [x.strip() for x in out.splitlines()]
          assert jobs == [], f"jobs != []: {jobs}"
    '';
}
