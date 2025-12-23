# Not everyone has a suitable remote builder set up, so the cross-compilation
# tests that _include_ running the result are separate. That way, most people
# can run the majority of the test suite without the extra setup.

{ pkgs, ... }:
let

  remoteSystem =
    if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then "x86_64-linux" else "aarch64-linux";

  remoteCrossPkgs =
    import ../.. # nixpkgs
      {
        # NOTE: This is the machine that runs the build -  local from the
        #       'perspective' of the build script.
        localSystem = remoteSystem;

        # NOTE: Since this file can't control where the test will be _run_ we don't
        #       cross-compile _to_ a different system but _from_ a different system
        crossSystem = pkgs.stdenv.hostPlatform.system;
      };

  hello1 = remoteCrossPkgs.dockerTools.buildImage {
    name = "hello1";
    tag = "latest";
    copyToRoot = remoteCrossPkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ remoteCrossPkgs.hello ];
    };
  };

  hello2 = remoteCrossPkgs.dockerTools.buildLayeredImage {
    name = "hello2";
    tag = "latest";
    contents = remoteCrossPkgs.hello;
  };

in
{
  name = "docker-tools";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ roberth ];
  };

  nodes = {
    docker =
      { ... }:
      {
        virtualisation = {
          diskSize = 2048;
          docker.enable = true;
        };
      };
  };

  testScript = ''
    docker.wait_for_unit("sockets.target")

    with subtest("Ensure cross compiled buildImage image can run."):
        docker.succeed(
            "docker load --input='${hello1}'"
        )
        assert "Hello, world!" in docker.succeed(
            "docker run --rm ${hello1.imageName} hello",
        )
        docker.succeed(
            "docker rmi ${hello1.imageName}",
        )

    with subtest("Ensure cross compiled buildLayeredImage image can run."):
        docker.succeed(
            "docker load --input='${hello2}'"
        )
        assert "Hello, world!" in docker.succeed(
            "docker run --rm ${hello2.imageName} hello",
        )
        docker.succeed(
            "docker rmi ${hello2.imageName}",
        )
  '';
}
