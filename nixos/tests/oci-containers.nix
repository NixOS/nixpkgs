{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  lib ? pkgs.lib,
}:

let

  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;

  serviceName = "nginxtest"; # different on purpose to verify proper systemd unit generation

  mkOCITest =
    backend:
    makeTest {
      name = "oci-containers-${backend}";

      meta.maintainers = lib.teams.serokell.members ++ (with lib.maintainers; [ benley ]);

      nodes = {
        ${backend} =
          { pkgs, ... }:
          {
            virtualisation.oci-containers = {
              inherit backend;
              containers.nginx = {
                inherit serviceName;
                image = "nginx-container";
                imageStream = pkgs.dockerTools.examples.nginxStream;
                ports = [ "8181:80" ];
                capabilities = {
                  CAP_AUDIT_READ = true;
                  CAP_AUDIT_WRITE = false;
                };
                privileged = false;
                devices = [
                  "/dev/random:/dev/random"
                ];
              };
            };

            # Stop systemd from killing remaining processes if ExecStop script
            # doesn't work, so that proper stopping can be tested.
            systemd.services.${serviceName}.serviceConfig.KillSignal = "SIGCONT";
          };
      };

      testScript = ''
        import json

        start_all()
        ${backend}.wait_for_unit("${serviceName}.service")
        ${backend}.wait_for_open_port(8181)
        ${backend}.wait_until_succeeds("curl -f http://localhost:8181 | grep Hello")
        output = json.loads(${backend}.succeed("${backend} inspect nginx --format json").strip())[0]
        ${backend}.succeed("systemctl stop ${serviceName}.service", timeout=10)
        assert output['HostConfig']['CapAdd'] == ["CAP_AUDIT_READ"]
        assert output['HostConfig']['CapDrop'] == ${
          if backend == "docker" then "[\"CAP_AUDIT_WRITE\"]" else "[]"
        } # Rootless podman runs with no capabilities so it cannot drop them
        assert output['HostConfig']['Privileged'] == False
        assert output['HostConfig']['Devices'] == [{'PathOnHost': '/dev/random', 'PathInContainer': '/dev/random', 'CgroupPermissions': '${
          if backend == "docker" then "rwm" else ""
        }'}]
      ''
      + lib.strings.optionalString (backend == "podman") ''
        assert output['Config']['Labels']['PODMAN_SYSTEMD_UNIT'] == '${serviceName}.service'
      '';
    };

  podmanRootlessTests = lib.genAttrs [ "conmon" "healthy" ] (
    type:
    makeTest {
      name = "oci-containers-podman-rootless-${type}";
      meta.maintainers = lib.teams.flyingcircus.members ++ [ lib.maintainers.ma27 ];
      nodes = {
        podman =
          { pkgs, ... }:
          {
            environment.systemPackages = [ pkgs.redis ];
            users.groups.redis = { };
            users.users.redis = {
              isSystemUser = true;
              group = "redis";
              home = "/var/lib/redis";
              linger = type == "healthy";
              createHome = true;
              uid = 2342;
              subUidRanges = [
                {
                  count = 65536;
                  startUid = 2147483646;
                }
              ];
              subGidRanges = [
                {
                  count = 65536;
                  startGid = 2147483647;
                }
              ];
            };
            virtualisation.oci-containers = {
              backend = "podman";
              containers.redis = {
                image = "redis:latest";
                imageFile = pkgs.dockerTools.examples.redis;
                ports = [ "6379:6379" ];
                podman = {
                  user = "redis";
                  sdnotify = type;
                };
              };
            };
          };
      };

      testScript = ''
        start_all()
        podman.wait_for_unit("podman-redis.service")
        ${lib.optionalString (type != "healthy") ''
          podman.wait_for_open_port(6379)
        ''}
        podman.wait_until_succeeds("set -eo pipefail; echo 'keys *' | redis-cli")
      '';
    }
  );
in
{
  docker = mkOCITest "docker";
  podman = mkOCITest "podman";
  podman-rootless-conmon = podmanRootlessTests.conmon;
  podman-rootless-healthy = podmanRootlessTests.healthy;
}
