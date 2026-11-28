# this test checks that configuration propagates from a base image to its derived image

{ pkgs, lib, ... }:
let
  baseTestImage = pkgs.dockerTools.buildImage {
    name = "config-propagation-base";
    tag = "latest";
    config = {
      Cmd = [
        (lib.getExe pkgs.bash)
        "-c"
        "echo $INPUT_BASE $INPUT_DERIVED"
      ];
      Env = [ "INPUT_BASE=foo" ];
    };
  };

  derivedTestImage = pkgs.dockerTools.buildImage {
    name = "config-propagation-derived";
    tag = "latest";
    fromImage = baseTestImage;
    config = {
      Env = [ "INPUT_DERIVED=bar" ];
    };
  };
in
{
  name = "docker-tools";
  meta = with lib.maintainers; {
    maintainers = [
      SamirTalwar
    ];
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

    with subtest("config propagation"):
        docker.succeed(
            "docker image load --input='${derivedTestImage}'",
            "docker image inspect ${derivedTestImage.imageName}",
            "docker container run --rm ${derivedTestImage.imageName} | diff /dev/stdin <(echo foo bar)",
        )
  '';
}
