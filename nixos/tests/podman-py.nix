import ./make-test-python.nix ({ pkgs, ... }:
  let
    pythonWithPackages = pkgs.python3.withPackages (ps:
      with ps; [
        pyxdg
        requests
        sphinx
        tomli
        urllib3

        pytest

        fixtures
        requests-mock
      ]);

    alpineImage = pkgs.dockerTools.pullImage {
      imageName = "quay.io/libpod/alpine";
      imageDigest = "sha256:fa93b01658e3a5a1686dc3ae55f170d8de487006fb53a28efcd12ab0710a2e5f"; # 3.10.2
      sha256 = "sha256-ewZ3QgwUwt1CJJeWSvZsGb+xBleFJYcnBG5eUh2rTDY=";
    };
  in {
    name = "podman-py";

    nodes.machine.virtualisation.podman.enable = true;

    testScript = ''
      machine.wait_for_unit('sockets.target')

      # this image is required for tests
      machine.execute('${pkgs.podman}/bin/podman load -i ${alpineImage}')

      machine.succeed('${pythonWithPackages}/bin/pytest ${pkgs.python3Packages.podman.src}/podman/tests/integration')
    '';
  })
