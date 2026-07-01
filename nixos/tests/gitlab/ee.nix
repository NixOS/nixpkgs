# NixOS integration test for GitLab Enterprise Edition (EE) with an offline
# license file (services.gitlab.enterprise.licenseFile).
#
# Proves the full offline path: the module loads the .gitlab-license file during
# gitlab-db-config, and the license ends up in the database. The license blob is
# signed by a throwaway keypair that GitLab is made to trust (see ee-lib.nix), so
# no real GitLab-issued license is needed. Also covers the EE smoke checks:
# FOSS_ONLY=false, the -ee VERSION suffix, and that the EE-only license rake tasks
# are present.
#
# The EE package is unfree and large, so this test needs NIXPKGS_ALLOW_UNFREE=1 and
# won't run in Hydra CI unless allowUnfree is set in the evaluation context.
#
# Run with:
#   [nixpkgs]$ NIXPKGS_ALLOW_UNFREE=1 nix-build -A nixosTests.gitlab.gitlab-ee

{ pkgs, lib, ... }:

let
  eeLib = import ./ee-lib.nix { inherit pkgs lib; };
in
{
  name = "gitlab-ee";

  meta = {
    maintainers = with lib.maintainers; [ rane ];
  };

  nodes.gitlab =
    { ... }:
    lib.mkMerge [
      eeLib.commonNode
      {
        # The db-config service reads the license file as the gitlab user, so it
        # must be gitlab-readable (sops-nix/agenix would own it by gitlab in real use).
        systemd.tmpfiles.rules = [
          "d /var/keys 0755 root root -"
          "C+ /var/keys/gitlab-license 0400 gitlab gitlab - ${eeLib.licenseFixture}/license-blob"
        ];

        services.gitlab = eeLib.commonGitlab // {
          extraGitlabRb = eeLib.encryptionKeyOverride;
          enterprise = {
            enable = true;
            licenseFile = "/var/keys/gitlab-license";
            # Set purely to assert env injection; inert for the file path.
            customerPortalUrl = "https://portal.test.example.com";
            licenseMode = "test";
          };
        };
      }
    ];

  testScript =
    { nodes, ... }:
    let
      statePath = nodes.gitlab.services.gitlab.statePath;
    in
    eeLib.helpers
    + ''
      gitlab.start()

      with subtest("GitLab EE boots and serves the sign-in page"):
          gitlab.wait_for_unit("gitlab.service")
          gitlab.wait_for_file("${statePath}/tmp/sockets/gitlab.socket")
          gitlab.wait_until_succeeds("curl -sSf http://localhost/users/sign_in")

      with subtest("The EE package is installed"):
          # FOSS_ONLY=false is injected into the service environment by the EE
          # package passthru; CE sets it to "true". Check via systemctl because the
          # env is set by the makeWrapper wrappers, not the gitlab user's login env.
          gitlab.succeed(
              "systemctl show gitlab.service --property=Environment | grep -q 'FOSS_ONLY=false'"
          )
          gitlab.succeed(
              "GITLAB_PATH=$(systemctl show gitlab.service --property=Environment "
              + "| grep -oP 'GITLAB_PATH=\\K[^ ]+')"
              + " && grep -q -- '-ee' \"$GITLAB_PATH/VERSION\""
          )

      with subtest("Enterprise env vars reach the service environment"):
          for svc in ["gitlab.service", "gitlab-sidekiq.service"]:
              gitlab.succeed(
                  f"systemctl show {svc} --property=Environment "
                  f"| grep -q 'CUSTOMER_PORTAL_URL=https://portal.test.example.com'"
              )
              gitlab.succeed(
                  f"systemctl show {svc} --property=Environment "
                  f"| grep -q 'GITLAB_LICENSE_MODE=test'"
              )

      with subtest("licenseFile is wired into db-config"):
          script = db_config_script(gitlab)
          assert "GITLAB_LICENSE_FILE='/var/keys/gitlab-license'" in script, (
              f"GITLAB_LICENSE_FILE not found in db-config script:\n{script}"
          )

      with subtest("The license file is loaded into the database"):
          wait_db_config(gitlab)
          plan = license_plan(gitlab)
          assert plan == "ultimate", f"expected ultimate license in DB, got {plan!r}"
    '';
}
