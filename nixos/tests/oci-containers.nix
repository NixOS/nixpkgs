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
            imageFile = pkgs.dockerTools.examples.nginx;
            ports = ["8181:80"];
          };
        };
      };
    };

    testScript = ''
      start_all()
      ${backend}.wait_for_unit("${backend}-nginx.service")
      ${backend}.wait_for_open_port(8181)
      ${backend}.wait_until_succeeds("curl -f http://localhost:8181 | grep Hello")
    '';
  };

in
lib.foldl' (attrs: backend: attrs // { ${backend} = mkOCITest backend; }) {} [
  "docker"
  "podman"
]
