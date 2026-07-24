# NixOS integration test for GitLab Enterprise Edition (EE) cloud activation
# (services.gitlab.enterprise.activationCodeFile).
#
# Proves the full cloud-activation path: the module reads the activation code and
# sends it to customerPortalUrl during gitlab-db-config, and the license returned
# by the portal ends up in the database. A mock Customers Portal stands in for
# customers.gitlab.com, returning a license blob signed by a throwaway keypair that
# GitLab is made to trust (see ee-lib.nix), so no real activation code is needed.
#
# The EE package is unfree and large, so this test needs NIXPKGS_ALLOW_UNFREE=1 and
# won't run in Hydra CI unless allowUnfree is set in the evaluation context.
#
# Run with:
#   [nixpkgs]$ NIXPKGS_ALLOW_UNFREE=1 nix-build -A nixosTests.gitlab.gitlab-ee-activation

{ pkgs, lib, ... }:

let
  eeLib = import ./ee-lib.nix { inherit pkgs lib; };
in
{
  name = "gitlab-ee-activation";

  meta = {
    maintainers = with lib.maintainers; [ rane ];
  };

  nodes.gitlab =
    { ... }:
    lib.mkMerge [
      eeLib.commonNode
      {
        systemd.tmpfiles.rules = [
          "d /var/keys 0755 root root -"
          "f /var/keys/activation-code 0400 gitlab gitlab - TESTACTIVATIONCODE123456"
        ];

        # Mock of the Customers Portal GraphQL endpoint. Records the request body and
        # returns the fixture blob as cloudActivationActivate.licenseKey.
        systemd.services.mock-portal = {
          description = "Mock GitLab Customers Portal";
          wantedBy = [ "multi-user.target" ];
          before = [ "gitlab-db-config.service" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = pkgs.writeShellScript "mock-portal" ''
              ${pkgs.python3}/bin/python3 ${pkgs.writeText "mock-portal.py" ''
                import http.server, json

                with open("${eeLib.licenseFixture}/license-blob") as f:
                    BLOB = f.read()

                class Handler(http.server.BaseHTTPRequestHandler):
                    def do_POST(self):
                        n = int(self.headers.get("Content-Length", 0))
                        # Append every request: GitLab makes follow-up POSTs (seat-link,
                        # cloud connector) after activation, so we must not overwrite.
                        with open("/tmp/portal-requests.log", "ab") as out:
                            out.write(self.rfile.read(n) + b"\n")
                        resp = json.dumps({
                            "data": {
                                "cloudActivationActivate": {
                                    "licenseKey": BLOB,
                                    "futureSubscriptions": [],
                                    "newSubscription": None,
                                    "errors": []
                                }
                            }
                        }).encode()
                        self.send_response(200)
                        self.send_header("Content-Type", "application/json")
                        self.send_header("Content-Length", str(len(resp)))
                        self.end_headers()
                        self.wfile.write(resp)
                    def log_message(self, *_):
                        pass

                http.server.HTTPServer(("127.0.0.1", 9999), Handler).serve_forever()
              ''}
            '';
          };
        };

        systemd.services.gitlab-db-config = {
          after = [ "mock-portal.service" ];
          wants = [ "mock-portal.service" ];
        };

        services.gitlab = eeLib.commonGitlab // {
          extraGitlabRb = eeLib.encryptionKeyOverride + eeLib.allowLocalRequestsOverride;
          enterprise = {
            enable = true;
            activationCodeFile = "/var/keys/activation-code";
            customerPortalUrl = "http://127.0.0.1:9999";
          };
        };
      }
    ];

  testScript =
    { ... }:
    eeLib.helpers
    + ''
      gitlab.start()
      gitlab.wait_for_unit("multi-user.target")

      with subtest("activationCodeFile is wired into db-config"):
          script = db_config_script(gitlab)
          assert "GITLAB_ACTIVATION_CODE" in script, (
              f"GITLAB_ACTIVATION_CODE not found in db-config script:\n{script}"
          )
          assert "/var/keys/activation-code" in script

      with subtest("The activated license is written to the database"):
          wait_db_config(gitlab)
          plan = license_plan(gitlab)
          assert plan == "ultimate", f"expected ultimate license in DB, got {plan!r}"

      with subtest("The activation code was sent to customerPortalUrl"):
          gitlab.succeed("grep -qF TESTACTIVATIONCODE123456 /tmp/portal-requests.log")
    '';
}
