{ pkgs, ... }:
let
  inherit (pkgs) lib;
  mainTf = pkgs.writeText "main.tf" ''
    terraform {
      required_version = ">= 1.0.0"
    }

    resource "terraform_data" "example" {
      input = "hello-atlantis"
    }
  '';
in
{
  name = "atlantis";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      jwygoda
      tebriel
    ];
  };

  nodes.machine =
    { lib, pkgs, ... }:
    {
      virtualisation.memorySize = 2048;

      services.gitea = {
        enable = true;
        database.type = "sqlite3";
        settings = {
          server.ROOT_URL = "http://127.0.0.1:3000/";
          service.DISABLE_REGISTRATION = true;
          webhook.ALLOWED_HOST_LIST = "*";
        };
      };

      services.atlantis = {
        enable = true;
        openFirewall = true;
        extraPackages = [ pkgs.opentofu ];
        environmentFile = "/run/secrets/atlantis.env";
        settings = {
          atlantis-url = "http://127.0.0.1:4141";
          gitea-base-url = "http://127.0.0.1:3000";
          gitea-user = "test";
          gitea-webhook-secret = "webhooksecret";
          repo-allowlist = "*";
          write-git-creds = true;
          default-tf-distribution = "opentofu";
          default-tf-version = pkgs.opentofu.version;
          tf-download = false;
        };
      };

      # Start Atlantis after Gitea user & API token are initialized
      systemd.services.atlantis.wantedBy = lib.mkForce [ ];

      environment.systemPackages = with pkgs; [
        curl
        git
        gitea
        jq
        opentofu
      ];
    };

  testScript = ''
    import json

    start_all()

    machine.wait_for_unit("gitea.service")
    machine.wait_for_open_port(3000)
    machine.succeed("curl --fail http://127.0.0.1:3000/")

    with subtest("Initialize Gitea admin user and API token"):
        machine.succeed(
            "su -l gitea -c 'GITEA_WORK_DIR=/var/lib/gitea ${lib.getExe pkgs.gitea} admin user create "
            "--username test --password totallysafe --email test@localhost --admin'"
        )

        api_token = machine.succeed(
            "curl --fail -s -X POST http://test:totallysafe@127.0.0.1:3000/api/v1/users/test/tokens "
            "-H 'Accept: application/json' -H 'Content-Type: application/json' "
            "-d '{\"name\":\"atlantis\",\"scopes\":[\"all\"]}' | jq -r '.sha1'"
        ).strip()

    with subtest("Create repository and webhook for Atlantis"):
        machine.succeed(
            "curl --fail -s -X POST http://127.0.0.1:3000/api/v1/user/repos "
            f"-H 'Authorization: token {api_token}' -H 'Content-Type: application/json' "
            "-d '{\"name\":\"infra\",\"auto_init\":true,\"default_branch\":\"main\"}'"
        )

        webhook_payload = json.dumps({
            "type": "gitea",
            "config": {
                "url": "http://127.0.0.1:4141/events",
                "content_type": "json",
                "secret": "webhooksecret",
            },
            "events": ["push", "pull_request", "issue_comment"],
            "active": True,
        })
        machine.succeed(
            f"curl --fail -s -X POST http://127.0.0.1:3000/api/v1/repos/test/infra/hooks "
            f"-H 'Authorization: token {api_token}' -H 'Content-Type: application/json' "
            f"-d '{webhook_payload}'"
        )

    with subtest("Start Atlantis service"):
        machine.succeed("mkdir -p /run/secrets")
        machine.succeed(f"echo ATLANTIS_GITEA_TOKEN={api_token} > /run/secrets/atlantis.env")
        machine.succeed("systemctl start atlantis.service")
        machine.wait_for_unit("atlantis.service")
        machine.wait_for_open_port(4141)
        machine.succeed("curl --fail http://127.0.0.1:4141/healthz")

    with subtest("Push branch with Terraform configuration and open Pull Request"):
        machine.succeed("git config --global user.email test@localhost")
        machine.succeed("git config --global user.name test")
        machine.succeed(
            f"git clone http://test:{api_token}@127.0.0.1:3000/test/infra.git /tmp/infra"
        )
        machine.succeed("git -C /tmp/infra checkout -b add-tf")
        machine.succeed("cp ${mainTf} /tmp/infra/main.tf")
        machine.succeed("git -C /tmp/infra add main.tf")
        machine.succeed("git -C /tmp/infra commit -m 'Add terraform resource'")
        machine.succeed("git -C /tmp/infra push origin add-tf")

        pr_payload = json.dumps({
            "base": "main",
            "head": "add-tf",
            "title": "Add Terraform resource",
        })
        machine.succeed(
            f"curl --fail -s -X POST http://127.0.0.1:3000/api/v1/repos/test/infra/pulls "
            f"-H 'Authorization: token {api_token}' -H 'Content-Type: application/json' "
            f"-d '{pr_payload}'"
        )

    with subtest("Verify Atlantis automatically runs plan on PR"):
        machine.wait_until_succeeds(
            f"curl --fail -s http://127.0.0.1:3000/api/v1/repos/test/infra/issues/1/comments "
            f"-H 'Authorization: token {api_token}' | jq -r '.[].body' | grep -i 'Plan: 1 to add'"
        )

    with subtest("Verify Atlantis executes apply on comment"):
        apply_comment = json.dumps({"body": "atlantis apply"})
        machine.succeed(
            f"curl --fail -s -X POST http://127.0.0.1:3000/api/v1/repos/test/infra/issues/1/comments "
            f"-H 'Authorization: token {api_token}' -H 'Content-Type: application/json' "
            f"-d '{apply_comment}'"
        )
        machine.wait_until_succeeds(
            f"curl --fail -s http://127.0.0.1:3000/api/v1/repos/test/infra/issues/1/comments "
            f"-H 'Authorization: token {api_token}' | jq -r '.[].body' | grep -i 'Apply complete'"
        )
  '';
}
