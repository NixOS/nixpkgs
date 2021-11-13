# Test for cntr tool
{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; }, lib ? pkgs.lib }:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;

  mkOCITest = backend:
    makeTest {
      name = "cntr-${backend}";

      meta = { maintainers = with lib.maintainers; [ sorki mic92 ]; };

      nodes = {
        ${backend} = { pkgs, ... }: {
          environment.systemPackages = [ pkgs.cntr ];
          virtualisation.oci-containers = {
            inherit backend;
            containers.nginx = {
              image = "nginx-container";
              imageFile = pkgs.dockerTools.examples.nginx;
              ports = [ "8181:80" ];
            };
          };
        };
      };

      testScript = ''
        start_all()
        ${backend}.wait_for_unit("${backend}-nginx.service")
        result = ${backend}.wait_until_succeeds(
            "cntr attach -t ${backend} nginx sh -- -c 'curl localhost | grep Hello'"
        )
        assert "Hello" in result
      '';
    };

  mkContainersTest = makeTest {
    name = "cntr-containers";

    meta = with pkgs.lib.maintainers; { maintainers = [ sorki mic92 ]; };

    machine = { lib, ... }: {
      environment.systemPackages = [ pkgs.cntr ];
      containers.test = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "172.16.0.1";
        localAddress = "172.16.0.2";
        config = { };
      };
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("container@test.service")
      machine.succeed("cntr attach test sh -- -c 'ping -c5 172.16.0.1'")
    '';
  };
in {
  nixos-container = mkContainersTest;
} // (lib.foldl' (attrs: backend: attrs // { ${backend} = mkOCITest backend; })
  { } [ "docker" "podman" ])
