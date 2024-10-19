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
      import json

      start_all()
      ${backend}.wait_for_unit("${backend}-nginx.service")
      ${backend}.wait_for_open_port(8181)
      ${backend}.wait_until_succeeds("curl -f http://localhost:8181 | grep Hello")
      output = json.loads(${backend}.succeed("${backend} inspect nginx --format json").strip())[0]
      ${backend}.succeed("systemctl stop ${backend}-nginx.service", timeout=10)
      assert output['HostConfig']['CapAdd'][0] == "NET_ADMIN"
      assert output['HostConfig']['CapDrop'][0] == "WAKE_ALARM"
      assert output['HostConfig']['Privileged'] == True
      assert output['HostConfig']['Devices'][0] == {'PathOnHost': '/dev/snd', 'PathInContainer': '/dev/snd', 'CgroupPermissions': 'rwm'}
    '';
  };

in
lib.foldl' (attrs: backend: attrs // { ${backend} = mkOCITest backend; }) {} [
  "docker"
  "podman"
]
