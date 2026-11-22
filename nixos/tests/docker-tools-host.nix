# Builds the same image with the dockerTools of the machine running the test
# and with the dockerTools of the VM, and checks that the two are identical.
# On a Linux host both are the same system. On a Darwin host this checks that
# an image built on macOS matches one built on Linux.
# nix-build -A nixosTests.docker-tools-host --argstr system aarch64-darwin
{
  config,
  hostPkgs,
  lib,
  ...
}:
let
  pkgs = config.node.pkgs;

  image =
    dockerTools:
    dockerTools.buildLayeredImage {
      name = "docker-tools-host";
      tag = "latest";
      architecture = pkgs.stdenv.hostPlatform.go.GOARCH;
      compressor = "none";
      contents = [ pkgs.hello ];
      # A symlink in the customisation layer as well.
      extraCommands = "ln -s bin/hello hello";
      config.Cmd = [ "/bin/hello" ];
    };

  fromHost = image hostPkgs.dockerTools;
  fromNode = image pkgs.dockerTools;
in
{
  name = "docker-tools-host";
  meta = with lib.maintainers; {
    maintainers = [ mikroskeem ];
  };

  nodes = {
    docker =
      { ... }:
      {
        virtualisation = {
          diskSize = 3072;
          docker.enable = true;
        };
      };
  };

  testScript = ''
    docker.wait_for_unit("sockets.target")

    with subtest("Images built by the host and by the VM are identical"):
        docker.succeed("cmp ${fromHost} ${fromNode}")

    with subtest("The image built by the host runs"):
        docker.succeed("docker load --input='${fromHost}'")
        docker.succeed("docker run --rm docker-tools-host:latest | grep 'Hello, world!'")
  '';
}
