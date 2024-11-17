{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  lib ? pkgs.lib,
}:

let

  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;

in
makeTest {
  name = "oci-containers-systemd";

  meta.maintainers =
    lib.teams.serokell.members
    ++ (with lib.maintainers; [
      benley
      mkaito
    ]);

  nodes = {
    server = {
      virtualisation.oci-containers = {
        backend = "systemd";
        containers.nginx = {
          # ports = ["8182:80"]; # this driver always uses host networking
          image = "nginx";
          imageFile = pkgs.dockerTools.pullImage {
            imageName = "nginx";
            imageDigest = "sha256:a8f1c6d64295f107da7319cc1af9b7d0ce4d34d347390589223091e05137c9df";
            sha256 = "sha256-69/y0icMlThWCt2J7SS3Pg1mmdB4M90+PtYs+N5CAMo=";
          };
        };
      };
    };
  };
  testScript = ''
    start_all()
    server.wait_for_unit("systemd-nginx.service")
    server.wait_for_open_port(80)
    server.wait_until_succeeds("curl -f http://server:80 | grep 'Welcome to nginx!'")
  '';
}
