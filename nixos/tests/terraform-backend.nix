{ lib, pkgs, ... }:
let
  kmsKeyFile = "/var/lib/terraform-backend-kms/kms-key";

  baoAddr = "http://127.0.0.1:8200";

  stateUrl = "http://127.0.0.1:8080/state/testproject/main";

  # The `jwt` auth backend compares the `terraform-backend.project` and
  # `terraform-backend.state` claims of the token against the requested state, so the
  # `tf-other` token is a valid token that must not open `testproject`.
  roles = {
    tf = "testproject";
    tf-other = "otherproject";
  };

  # The `default` policy of OpenBao does not grant the token endpoint.
  tokenPolicy = pkgs.writeText "terraform-backend-token.hcl" (
    lib.concatStrings (
      lib.mapAttrsToList (role: _: ''
        path "identity/oidc/token/${role}" {
          capabilities = ["read"]
        }
      '') roles
    )
  );

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
    services.openbao = {
      enable = true;

      settings = {
        listener.default = {
          type = "tcp";
          address = "127.0.0.1:8200";
          tls_disable = true;
        };

        api_addr = baoAddr;

        storage.file.path = "/var/lib/openbao";
      };
    };

    environment.variables = {
      BAO_ADDR = baoAddr;
      BAO_FORMAT = "json";
    };

    services.terraform-backend = {
      enable = true;
      inherit kmsKeyFile;

      settings = {
        # The `jwt` backend takes the issuer from this address.
        VAULT_ADDR = baoAddr;

        # The `basic` backend accepts every password, so this makes `jwt` the only way
        # in, and the test can show that a `basic` request is refused.
        AUTH_BASIC_ENABLED = false;
      };
    };

    # The key is written at runtime, as a secret manager would do it, so the service
    # cannot start at boot.
    systemd.services.terraform-backend.wantedBy = lib.mkForce [ ];

    environment.systemPackages = [
      (pkgs.opentofu.withPlugins (p: [ p.hashicorp_random ]))
      pkgs.curl
    ];
  };

  testScript = ''
    import json
    import shlex

    def tofu(directory, token, command):
        env = " ".join(
            [
                "HOME=/tmp",
                "TF_IN_AUTOMATION=1",
                "TF_HTTP_ADDRESS=${stateUrl}",
                "TF_HTTP_LOCK_ADDRESS=${stateUrl}",
                "TF_HTTP_UNLOCK_ADDRESS=${stateUrl}",
                "TF_HTTP_USERNAME=jwt",
                "TF_HTTP_PASSWORD=" + shlex.quote(token),
            ]
        )
        return machine.succeed(f"cd {directory} && env {env} tofu {command}")

    def state_status(user, secret):
        # Reports the HTTP status, so that a refusal is told apart from an empty state.
        return machine.succeed(
            "curl -s -o /dev/null -w '%{http_code}' -u "
            + shlex.quote(f"{user}:{secret}")
            + " ${stateUrl}"
        ).strip()

    machine.wait_for_unit("multi-user.target")

    with subtest("openbao initializes and unseals"):
        machine.wait_for_unit("openbao.service")
        machine.wait_for_open_port(8200)
        init = json.loads(machine.succeed("bao operator init -key-shares=1 -key-threshold=1"))
        machine.succeed(f"bao operator unseal {init['unseal_keys_b64'][0]}")
        machine.succeed(f"bao login {init['root_token']}")

    with subtest("openbao issues terraform-backend tokens to an entity"):
        machine.succeed("bao write identity/oidc/key/tf allowed_client_ids=terraform-backend")

        for role, project in ${builtins.toJSON roles}.items():
            # OpenBao reads the template for `{{ ... }}` sequences, so two closing
            # braces next to each other are an unbalanced sequence to it.
            template = json.dumps(
                {"terraform-backend": {"project": project, "state": "main"}}
            ).replace("}}", "} }")
            machine.succeed(
                f"bao write identity/oidc/role/{role} key=tf client_id=terraform-backend"
                f" ttl=1h template={shlex.quote(template)}"
            )

        machine.succeed("bao policy write terraform-backend ${tokenPolicy}")

        # The token endpoint needs an entity. A token of the `userpass` user gets one
        # through an alias on that mount.
        machine.succeed("bao auth enable userpass")
        accessor = json.loads(machine.succeed("bao auth list"))["userpass/"]["accessor"]
        machine.succeed(
            "bao write auth/userpass/users/tfuser password=tfpassword"
            " token_policies=terraform-backend"
        )
        entity = json.loads(machine.succeed("bao write identity/entity name=tfclient"))
        machine.succeed(
            f"bao write identity/entity-alias name=tfuser"
            f" canonical_id={entity['data']['id']} mount_accessor={accessor}"
        )

        machine.succeed("bao login -method=userpass username=tfuser password=tfpassword")
        tokens = {
            role: json.loads(machine.succeed(f"bao read identity/oidc/token/{role}"))["data"]["token"]
            for role in ${builtins.toJSON (lib.attrNames roles)}
        }

    with subtest("the service starts with a key written at runtime"):
        machine.succeed(
            "head -c 32 /dev/urandom | base64 -w0"
            " | install -D -m 0400 /dev/stdin ${kmsKeyFile}"
        )
        machine.succeed("systemctl start terraform-backend.service")
        machine.wait_for_unit("terraform-backend.service")
        machine.wait_for_open_port(8080)
        machine.wait_for_open_port(8081)

    with subtest("health and metrics endpoints respond"):
        machine.succeed("curl --fail http://127.0.0.1:8080/health")
        machine.succeed("curl --fail http://127.0.0.1:8081/metrics | grep tfbackend_backend_info")

    with subtest("opentofu can write state with a token from openbao"):
        machine.succeed("mkdir -p /tmp/tf && cp ${mainTf} /tmp/tf/main.tf")
        tofu("/tmp/tf", tokens["tf"], "init -no-color")
        tofu("/tmp/tf", tokens["tf"], "apply -auto-approve -no-color")
        secret = tofu("/tmp/tf", tokens["tf"], "output -raw value").strip()
        machine.succeed("ls -A /var/lib/terraform-backend/states | grep .")

    with subtest("state is encrypted at rest"):
        # The grep below must be able to hit. `tofu state pull` gives the plain text that
        # the client sent, so a hit there proves that the secret is in the state verbatim,
        # that the shell quoting is correct, and that the value is not empty.
        assert len(secret) == 42, f"unexpected secret {secret!r}"
        assert '"' not in secret and "\\" not in secret, f"secret needs escaping: {secret!r}"
        tofu("/tmp/tf", tokens["tf"], "state pull > /tmp/plain.json")
        machine.succeed(f"grep -F -- {shlex.quote(secret)} /tmp/plain.json")
        machine.fail(
            f"grep -r --text -F -- {shlex.quote(secret)} /var/lib/terraform-backend/states/"
        )

    with subtest("state can be read back into a fresh working directory"):
        machine.succeed("mkdir -p /tmp/tf2 && cp ${mainTf} /tmp/tf2/main.tf")
        tofu("/tmp/tf2", tokens["tf"], "init -no-color")
        read_back = tofu("/tmp/tf2", tokens["tf"], "output -raw value").strip()
        assert read_back == secret, f"read back {read_back!r}, expected {secret!r}"

    with subtest("only a token that claims the state can read it"):
        # The first check is the positive control: the same request with the right token
        # reaches the state, so a refusal below is the claims and not the request.
        assert state_status("jwt", tokens["tf"]) == "200"
        assert state_status("jwt", tokens["tf-other"]) == "403"
        assert state_status("basic", "correct-horse-battery-staple") == "403"

    with subtest("state can be destroyed"):
        tofu("/tmp/tf", tokens["tf"], "destroy -auto-approve -no-color")
  '';
}
