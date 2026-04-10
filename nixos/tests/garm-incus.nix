# End-to-end test of GARM with the external incus provider and a local Gitea
# as the forge. GARM creates a runner instance from a locally imported NixOS
# container image, the runner registers with Gitea and executes a workflow.
# Everything runs offline: instead of fetching the runner release info and
# binary from gitea.com, a stub serves the gitea-actions-runner package.

{ lib, pkgs, ... }:

let
  releases = import ../release.nix {
    configuration =
      { pkgs, ... }:
      {
        # Strip documentation from the runner image.
        documentation.enable = lib.mkForce false;
        documentation.nixos.enable = lib.mkForce false;
        # Including a channel forces the image to be rebuilt on any change.
        system.installer.channel.enable = lib.mkForce false;
        environment.etc."nix/registry.json".text = lib.mkForce "{}";

        # GARM passes the runner install script via cloud-init user data.
        services.cloud-init.enable = true;
        services.cloud-init.settings.datasource_list = [ "LXD" ];

        systemd.tmpfiles.rules = [
          # cloud-init's LXD datasource only probes /dev/lxd/sock, while incus
          # mounts its (API-compatible) guest socket at /dev/incus.
          "L /dev/lxd - - - - /dev/incus"
          # Install script has a /bin/bash shebang.
          "L+ /bin/bash - - - - ${lib.getExe pkgs.bash}"
        ];

        # The install script expects the runner user to exist and to have
        # passwordless sudo. Normally both are set up by cloud-init, but the
        # sudoers.d drop-in cloud-init writes is not included by the sudoers
        # file on NixOS.
        users.groups.runner = { };
        users.users.runner = {
          isNormalUser = true;
          group = "runner";
          extraGroups = [ "wheel" ];
          shell = pkgs.bash;
        };
        security.sudo.wheelNeedsPassword = false;

        # The runner unit is installed at runtime by the install script.
        # NixOS expects units to set their PATH explicitly, leaving
        # the runner's unit without a shell.
        systemd.settings.Manager.DefaultEnvironment = "PATH=/run/current-system/sw/bin";

        environment.systemPackages = [
          # Runner binary served by the stub release feed is dynamically linked.
          # Include the package so it's runtime closure is present in the image.
          pkgs.gitea-actions-runner
          # Used by the install script.
          pkgs.curl
        ];
      };
  };
  incusImageMeta =
    releases.incusContainerMeta.${pkgs.stdenv.hostPlatform.system}
    + "/tarball/nixos-image-lxc-*-${pkgs.stdenv.hostPlatform.system}.tar.xz";
  incusImageRoot =
    releases.incusContainerImage.${pkgs.stdenv.hostPlatform.system}
    + "/nixos-lxc-image-${pkgs.stdenv.hostPlatform.system}.squashfs";

  # The host as seen from the runner containers.
  hostIP = "10.0.10.1";

  # /etc/systemd/system is a symlink into the store, so the stock install script
  # can't drop the runner unit there. Install the unit into /run/systemd/system
  # instead and start it without enabling (which would also write to /etc).
  # Persistence across reboots doesn't matter for ephemeral runners.
  runnerInstallTemplate =
    pkgs.runCommand "gitea-runner-install-nixos.tmpl" { inherit (pkgs.garm) src; }
      ''
        sed -e 's|/etc/systemd/system|/run/systemd/system|g' \
            -e 's|systemctl enable --now|systemctl start|g' \
            $src/internal/templates/userdata/gitea_linux_userdata.tmpl > $out
        grep -q /run/systemd/system $out
        ! grep -q 'enable --now' $out
      '';
in

{
  name = "garm-incus";
  meta.maintainers = with lib.maintainers; [ katexochen ];

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation = {
        cores = 2;
        memorySize = 4096;
        diskSize = 8192;
        incus = {
          enable = true;
          preseed = {
            networks = [
              {
                name = "incusbr0";
                type = "bridge";
                config = {
                  "ipv4.address" = "${hostIP}/24";
                  "ipv4.nat" = "true";
                };
              }
            ];
            profiles = [
              {
                name = "default";
                devices = {
                  eth0 = {
                    name = "eth0";
                    network = "incusbr0";
                    type = "nic";
                  };
                  root = {
                    path = "/";
                    pool = "default";
                    type = "disk";
                  };
                };
              }
            ];
            storage_pools = [
              {
                name = "default";
                driver = "dir";
              }
            ];
          };
        };
      };
      networking.nftables.enable = true;
      networking.firewall.trustedInterfaces = [ "incusbr0" ];

      services.gitea = {
        enable = true;
        settings.server = {
          HTTP_ADDR = "0.0.0.0";
          ROOT_URL = "http://${hostIP}:3000/";
        };
        settings.service.DISABLE_REGISTRATION = true;
        settings.actions.ENABLED = true;
      };

      # Stub for the gitea runner release feed and download server, replacing gitea.com.
      services.nginx = {
        enable = true;
        virtualHosts.tools = {
          listen = [
            {
              addr = "0.0.0.0";
              port = 8080;
            }
          ];
          root = pkgs.runCommand "garm-tools-stub" { } ''
            mkdir $out
            ln -s ${lib.getExe pkgs.gitea-actions-runner} $out/gitea-runner
            ln -s ${
              pkgs.writers.writeJSON "releases.json" [
                {
                  tag_name = "v${pkgs.gitea-actions-runner.version}";
                  name = "v${pkgs.gitea-actions-runner.version}";
                  assets = [
                    {
                      name = "gitea-runner-v${pkgs.gitea-actions-runner.version}-linux-amd64";
                      browser_download_url = "http://${hostIP}:8080/gitea-runner";
                    }
                  ];
                }
              ]
            } $out/releases.json
          '';
        };
      };

      services.garm = {
        enable = true;
        settings = {
          # Instances need to reach the API server for metadata and callbacks.
          apiserver.bind = "0.0.0.0";
          apiserver.webui.enable = true;
          jwt_auth.secret._secret = "/etc/garm-jwt-secret";
          database.passphrase._secret = "/etc/garm-db-passphrase";
          provider = [
            {
              name = "incus";
              description = "Incus external provider";
              provider_type = "external";
              external = {
                provider_executable = lib.getExe pkgs.garm-provider-incus;
                config_file = pkgs.writers.writeTOML "incus-provider.toml" {
                  unix_socket_path = "/var/lib/incus/unix.socket";
                  project_name = "default";
                  instance_type = "container";
                  include_default_profile = false;
                  # Never contacted, but required. Fixed in https://github.com/cloudbase/garm-provider-incus/pull/28
                  image_remotes.images = {
                    addr = "https://127.0.0.1";
                    public = true;
                    protocol = "simplestreams";
                  };
                };
              };
            }
          ];
        };
      };
      systemd.services.garm.serviceConfig.SupplementaryGroups = [ "incus-admin" ];

      environment.etc."garm-jwt-secret".text = "uhAVE3d5hiA4f93yPJcVo5xRbvUSbvVUSLGC8tG8WTzxtqtS";
      environment.etc."garm-db-passphrase".text = "6ahIZPHobW5SvKR92a8nrahCLsZvWBnD"; # must be exactly 32 chars

      environment.systemPackages = [
        pkgs.gitea
        pkgs.jq
      ];
    };

  testScript = ''
    import base64
    import json
    from datetime import timedelta

    workflow = base64.b64encode("""
    name: test
    on: [push]
    jobs:
      test:
        runs-on: nixos-test
        steps:
          - run: echo it works
    """.encode()).decode()

    machine.wait_for_unit("incus-preseed.service")
    machine.succeed("incus image import ${incusImageMeta} ${incusImageRoot} --alias nixos")

    machine.wait_for_unit("gitea.service")
    machine.wait_for_open_port(3000)
    machine.succeed(
        "su -l gitea -c 'GITEA_WORK_DIR=/var/lib/gitea gitea admin user create"
        " --username test --password totallysafe --email test@localhost'"
    )
    token = machine.succeed(
        "curl --fail --silent --show-error -X POST http://test:totallysafe@localhost:3000/api/v1/users/test/tokens"
        " -H 'Content-Type: application/json'"
        " -d '{\"name\": \"garm\", \"scopes\": [\"all\"]}'"
        " | jq -r .sha1"
    ).strip()
    machine.succeed(
        "curl --fail --silent --show-error -X POST http://localhost:3000/api/v1/user/repos"
        f" -H 'Authorization: token {token}'"
        " -H 'Content-Type: application/json'"
        " -d '{\"name\": \"test\", \"auto_init\": true}'"
    )

    machine.wait_for_unit("garm.service")
    machine.wait_for_open_port(9997)

    webui = machine.succeed("curl -fsS http://127.0.0.1:9997/ui/")
    assert "_app/immutable" in webui, f"expected web UI, got: {webui}"

    machine.succeed(
        "garm-cli init --name garm --url http://${hostIP}:9997"
        " --username admin --email admin@example.com"
        " --password CbIhvLQTXCCfVROvLcJ2B7A85BGWbasV"
    )
    machine.succeed(
        "garm-cli gitea endpoint create --name local"
        " --base-url http://${hostIP}:3000 --api-base-url http://${hostIP}:3000"
        " --tools-metadata-url http://${hostIP}:8080/releases.json"
    )
    machine.succeed(
        "garm-cli gitea credentials add --name test --endpoint local"
        f" --auth-type pat --pat-oauth-token {token} --description test"
    )
    machine.succeed(
        "garm-cli template create --name nixos --forge-type gitea --os-type linux"
        " --path ${runnerInstallTemplate}"
    )
    repo_id = machine.succeed(
        "garm-cli repo add --forge-type gitea --credentials test"
        " --owner test --name test --random-webhook-secret"
        " --format json | jq -r .id"
    ).strip()
    machine.succeed(
        f"garm-cli pool add --repo {repo_id} --enabled"
        " --provider-name incus --image nixos --flavor default"
        " --runner-install-template nixos"
        " --min-idle-runners 1 --max-runners 1 --tags nixos-test"
        " --os-type linux --os-arch amd64"
    )

    # The instance boots, downloads the runner from the stub server, registers
    # with Gitea through a GARM-provided registration token and reports back to GARM.

    def runner_idle(_):
        runners = json.loads(machine.succeed("garm-cli runner list --format json"))
        if not runners:
            return False
        assert runners[0]["runner_status"] != "failed", f"runner failed: {runners}"
        return runners[0]["runner_status"] == "idle"

    def dump_diagnostics():
        machine.log(machine.execute(
            "curl -sS http://localhost:3000/api/v1/repos/test/test/actions/tasks"
            f" -H 'Authorization: token {token}' 2>&1"
        )[1])
        machine.log(machine.execute(
            'incus exec "$(incus list -c n --format csv)" --force-noninteractive'
            " -- journalctl --no-pager -n 200 </dev/null 2>&1"
        )[1])

    def wait_with_diagnostics(description, condition):
        try:
            with machine.nested(description):
                retry(condition, timeout=timedelta(minutes=5))
        except Exception:
            dump_diagnostics()
            raise

    wait_with_diagnostics("waiting for the runner to register", runner_idle)

    instances = json.loads(machine.succeed("incus list --format json"))
    assert len(instances) == 1, f"expected one incus instance, got: {instances}"
    assert instances[0]["status"] == "Running", f"expected a running instance, got: {instances}"

    # Pushing a workflow triggers a run on the new runner.
    machine.succeed(
        "curl --fail --silent --show-error -X POST"
        " http://localhost:3000/api/v1/repos/test/test/contents/.gitea/workflows/test.yaml"
        f" -H 'Authorization: token {token}'"
        " -H 'Content-Type: application/json'"
        f' -d \'{{"content": "{workflow}", "message": "add workflow"}}\'''
    )

    def workflow_succeeded(_):
        tasks = json.loads(machine.succeed(
            "curl --fail --silent --show-error http://localhost:3000/api/v1/repos/test/test/actions/tasks"
            f" -H 'Authorization: token {token}'"
        ))
        return any(run["status"] == "success" for run in tasks["workflow_runs"])

    wait_with_diagnostics("waiting for the workflow run to succeed", workflow_succeeded)
  '';
}
