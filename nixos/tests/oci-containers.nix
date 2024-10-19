{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, lib ? pkgs.lib
}:

let

  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;

  mkOCITest = backend: makeTest {
    name = "oci-containers-${backend}";

    meta.maintainers = lib.teams.serokell.members
                       ++ (with lib.maintainers; [ benley mkaito ]);

    nodes = {
      ${backend} = { pkgs, ... }: {
        virtualisation.oci-containers = {
          inherit backend;
          containers.nginx = {
            image = "nginx-container";
            imageStream = pkgs.dockerTools.examples.nginxStream;
            ports = ["8181:80"];
            capAdd = {
              NET_ADMIN = true;
            };
            capDrop = {
              WAKE_ALARM = true;
            };
            networks = [
              "nginx-network"
            ];
            privileged = true;
            devices = [
              "/dev/snd:/dev/snd"
            ];
          };
        };

        # Stop systemd from killing remaining processes if ExecStop script
        # doesn't work, so that proper stopping can be tested.
        systemd.services."${backend}-nginx".serviceConfig.KillSignal = "SIGCONT";
      };
    };

    testScript = ''
      ${backend}.succeed("${backend} network create nginx-network", timeout=10)
      start_all()
      ${backend}.wait_for_unit("${backend}-nginx.service")
      ${backend}.wait_for_open_port(8181)
      ${backend}.wait_until_succeeds("curl -f http://localhost:8181 | grep Hello")
      ${backend}.succeed("systemctl stop ${backend}-nginx.service", timeout=10)
      ${backend}.succeed("${backend} inspect nginx --format '{{index .HostConfig.CapAdd 0 }}' | grep NET_ADMIN", timeout=10)
      ${backend}.succeed("${backend} inspect nginx --format '{{index .HostConfig.CapDrop 0 }}' | grep WAKE_ALARM", timeout=10)
      ${backend}.succeed("${backend} inspect nginx --format '{{ range $key, $value := .NetworkSettings.Networks }}{{ $key }}{{ end }}' | grep nginx-network", timeout=10)
      ${backend}.succeed("${backend} inspect nginx --format '{{ .HostConfig.Privileged }}' | grep true", timeout=10)
      ${backend}.succeed("${backend} inspect nginx --format '{{index .HostConfig.Devices 0 }}' | grep '{/dev/snd /dev/snd rwm}'", timeout=10)
    '';
  };

in
lib.foldl' (attrs: backend: attrs // { ${backend} = mkOCITest backend; }) {} [
  "docker"
  "podman"
]
