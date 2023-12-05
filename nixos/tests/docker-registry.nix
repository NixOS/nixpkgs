# This test runs docker-registry and check if it works

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "docker-registry";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ globin ironpinguin ];
  };

  nodes = {
    registry = { ... }: {
      services.dockerRegistry.enable = true;
      services.dockerRegistry.enableDelete = true;
      services.dockerRegistry.port = 8080;
      services.dockerRegistry.listenAddress = "0.0.0.0";
      services.dockerRegistry.enableGarbageCollect = true;
      networking.firewall.allowedTCPPorts = [ 8080 ];
    };

    client1 = { ... }: {
      virtualisation.docker.enable = true;
      virtualisation.docker.extraOptions = "--insecure-registry registry:8080";
    };

    client2 = { ... }: {
      virtualisation.docker.enable = true;
      virtualisation.docker.extraOptions = "--insecure-registry registry:8080";
    };
  };

  testScript = ''
    client1.start()
    client1.wait_for_unit("docker.service")
    client1.succeed("tar cv --files-from /dev/null | docker import - scratch")
    client1.succeed("docker tag scratch registry:8080/scratch")

    registry.start()
    registry.wait_for_unit("docker-registry.service")
    registry.wait_for_open_port(8080)
    client1.succeed("docker push registry:8080/scratch")

    client2.start()
    client2.wait_for_unit("docker.service")
    client2.succeed("docker pull registry:8080/scratch")
    client2.succeed("docker images | grep scratch")

    client2.succeed(
        "curl -fsS -X DELETE registry:8080/v2/scratch/manifests/$(curl -fsS -I -H\"Accept: application/vnd.docker.distribution.manifest.v2+json\" registry:8080/v2/scratch/manifests/latest | grep Docker-Content-Digest | sed -e 's/Docker-Content-Digest: //' | tr -d '\\r')"
    )

    registry.systemctl("start docker-registry-garbage-collect.service")
    registry.wait_until_fails("systemctl status docker-registry-garbage-collect.service")
    registry.wait_for_unit("docker-registry.service")

    registry.fail("ls -l /var/lib/docker-registry/docker/registry/v2/blobs/sha256/*/*/data")

    client1.succeed("docker push registry:8080/scratch")
    registry.succeed(
        "ls -l /var/lib/docker-registry/docker/registry/v2/blobs/sha256/*/*/data"
    )
  '';
})
