{ pkgs, ... }:
{
  name = "ghorg";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.etc = {
        "ghorg.env".text = ''
          GHORG_TOKEN=shared-token
        '';
        "ghorg-token".text = "per-job-token";
      };

      services.ghorg = {
        enable = true;
        startAt = "daily";
        environmentFile = "/etc/ghorg.env";
        package = pkgs.writeShellScriptBin "ghorg" ''
          set -eu
          printf '%s\n' "$@" > "$HOME/invocation.args"
          printf '%s\n' "$GHORG_RECLONE_PATH" > "$HOME/invocation.reclone-path"
          ${pkgs.coreutils}/bin/cp "$GHORG_RECLONE_PATH" "$HOME/reclone.yaml"
        '';
        jobs.nixos = {
          description = "Mirror NixOS repositories";
          postExecScript = "/bin/true";
          args = [
            "clone"
            "NixOS"
          ];
          tokenFile = "/etc/ghorg-token";
          settings = {
            scmType = "github";
            cloneType = "org";
            sshHostname = "github.com";
            baseUrl = "https://github.example.com";
            cloneProtocol = "ssh";
            outputDir = "github";
            concurrency = 4;
            preserveScmHostname = true;
            preserveDir = true;
            skipArchived = true;
            skipForks = true;
            branch = "main";
            cloneToPath = "/var/lib/ghorg/mirrors";
          };
        };
      };
    };

  testScript = ''
    machine.start()

    machine.wait_for_unit("ghorg.timer")
    machine.succeed("systemctl cat ghorg.timer | grep -F 'OnCalendar=daily'")

    machine.succeed("systemctl start ghorg.service")
    machine.succeed("systemctl show ghorg.service --property=Result --value | grep -Fx success")

    machine.succeed("test -d /var/lib/ghorg")
    machine.succeed("stat -c '%U:%G' /var/lib/ghorg | grep -Fx 'ghorg:ghorg'")
    machine.succeed("grep -Fx reclone /var/lib/ghorg/invocation.args")
    machine.succeed("test -s /var/lib/ghorg/reclone.yaml")
    machine.succeed("grep -F 'description: Mirror NixOS repositories' /var/lib/ghorg/reclone.yaml")
    machine.succeed("grep -F 'post_exec_script: /bin/true' /var/lib/ghorg/reclone.yaml")
    machine.succeed("grep -F -- '--token /etc/ghorg-token' /var/lib/ghorg/reclone.yaml")

    job_config = machine.succeed(
        "grep -oE '/nix/store/[^ ]+-ghorg-nixos\\.yaml' /var/lib/ghorg/reclone.yaml | head -n1"
    ).strip()
    assert job_config, "missing generated ghorg job config path"

    machine.succeed(f"grep -F 'GHORG_SCM_TYPE: github' {job_config}")
    machine.succeed(f"grep -F 'GHORG_CLONE_TYPE: org' {job_config}")
    machine.succeed(f"grep -F 'GHORG_SSH_HOSTNAME: github.com' {job_config}")
    machine.succeed(f"grep -F 'GHORG_SCM_BASE_URL: https://github.example.com' {job_config}")
    machine.succeed(f"grep -F 'GHORG_CLONE_PROTOCOL: ssh' {job_config}")
    machine.succeed(f"grep -F 'GHORG_OUTPUT_DIR: github' {job_config}")
    machine.succeed(f"grep -F 'GHORG_CONCURRENCY: 4' {job_config}")
    machine.succeed(f"grep -F 'GHORG_PRESERVE_SCM_HOSTNAME: true' {job_config}")
    machine.succeed(f"grep -F 'GHORG_PRESERVE_DIRECTORY_STRUCTURE: true' {job_config}")
    machine.succeed(f"grep -F 'GHORG_SKIP_ARCHIVED: true' {job_config}")
    machine.succeed(f"grep -F 'GHORG_SKIP_FORKS: true' {job_config}")
    machine.succeed(f"grep -F 'GHORG_BRANCH: main' {job_config}")
    machine.succeed(f"grep -F 'GHORG_ABSOLUTE_PATH_TO_CLONE_TO: /var/lib/ghorg/mirrors' {job_config}")
  '';
}
