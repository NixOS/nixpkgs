{ lib, pkgs, ... }:
let
  kmsKey = pkgs.writeText "kms-key" "b/rbQCdWbzx+x0trNRVp3ZWZ1Ta1nWbLxeJQjVolxgU=";

  stateUrl = "http://127.0.0.1:8080/state/testproject/main";

  # The `basic` auth backend namespaces state by `sha256("<password>:<state id>")`, so
  # the password decides which state a client sees.
  tofuEnv =
    password:
    lib.concatStringsSep " " [
      "HOME=/tmp"
      "TF_IN_AUTOMATION=1"
      "TF_HTTP_ADDRESS=${stateUrl}"
      "TF_HTTP_LOCK_ADDRESS=${stateUrl}"
      "TF_HTTP_UNLOCK_ADDRESS=${stateUrl}"
      "TF_HTTP_USERNAME=basic"
      "TF_HTTP_PASSWORD=${password}"
    ];

  ownerEnv = tofuEnv "correct-horse-battery-staple";
  otherEnv = tofuEnv "some-other-password";

  mainTf = pkgs.writeText "main.tf" ''
    terraform {
      required_providers {
        random = {
          source = "hashicorp/random"
        }
      }

      backend "http" {}
    }

    resource "random_password" "test" {
      length = 42
    }

    output "value" {
      value     = random_password.test.result
      sensitive = true
    }
  '';
in
{
  name = "terraform-backend";
  meta.maintainers = with lib.maintainers; [ kiara ];

  nodes.machine = {
    services.terraform-backend = {
      enable = true;
      kmsKeyFile = kmsKey;
    };

    environment.systemPackages = [
      (pkgs.opentofu.withPlugins (p: [ p.hashicorp_random ]))
      pkgs.curl
    ];
  };

  testScript = ''
    import json
    import shlex

    machine.wait_for_unit("terraform-backend.service")
    machine.wait_for_open_port(8080)
    machine.wait_for_open_port(8081)

    with subtest("the key file survives the store unmodified"):
        machine.succeed("test $(wc -c < ${kmsKey}) -eq 44")

    with subtest("health and metrics endpoints respond"):
        machine.succeed("curl --fail http://127.0.0.1:8080/health")
        machine.succeed("curl --fail http://127.0.0.1:8081/metrics | grep tfbackend_backend_info")

    with subtest("opentofu can write state through the backend"):
        machine.succeed("mkdir -p /tmp/tf && cp ${mainTf} /tmp/tf/main.tf")
        machine.succeed("cd /tmp/tf && env ${ownerEnv} tofu init -no-color")
        machine.succeed("cd /tmp/tf && env ${ownerEnv} tofu apply -auto-approve -no-color")
        secret = machine.succeed("cd /tmp/tf && env ${ownerEnv} tofu output -raw value").strip()
        machine.succeed("ls -A /var/lib/terraform-backend/states | grep .")

    with subtest("state is encrypted at rest"):
        # Positive control first: without it, a quoting bug or a missing directory would
        # make the negative check below pass for the wrong reason.
        machine.succeed(f"printf '%s' {shlex.quote(secret)} > /tmp/expected")
        machine.succeed(f"grep -F -- {shlex.quote(secret)} /tmp/expected")
        machine.fail(
            f"grep -r --text -F -- {shlex.quote(secret)} /var/lib/terraform-backend/states/"
        )

    with subtest("state can be read back into a fresh working directory"):
        machine.succeed("mkdir -p /tmp/tf2 && cp ${mainTf} /tmp/tf2/main.tf")
        machine.succeed("cd /tmp/tf2 && env ${ownerEnv} tofu init -no-color")
        read_back = machine.succeed("cd /tmp/tf2 && env ${ownerEnv} tofu output -raw value").strip()
        assert read_back == secret, f"read back {read_back!r}, expected {secret!r}"
        # Positive control for the namespacing check below: `tofu output -json` reports
        # the outputs of a state that has them, so an empty result there is meaningful.
        owner_outputs = json.loads(machine.succeed("cd /tmp/tf2 && env ${ownerEnv} tofu output -json"))
        assert list(owner_outputs) == ["value"], f"unexpected outputs {owner_outputs!r}"

    with subtest("a different password sees a different, empty state"):
        machine.succeed("mkdir -p /tmp/tf3 && cp ${mainTf} /tmp/tf3/main.tf")
        machine.succeed("cd /tmp/tf3 && env ${otherEnv} tofu init -no-color")
        other_outputs = json.loads(machine.succeed("cd /tmp/tf3 && env ${otherEnv} tofu output -json"))
        assert other_outputs == {}, f"another password saw outputs {other_outputs!r}"

    with subtest("state can be destroyed"):
        machine.succeed("cd /tmp/tf && env ${ownerEnv} tofu destroy -auto-approve -no-color")
  '';
}
