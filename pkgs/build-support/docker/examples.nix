# Examples of using the docker tools to build packages.
#
# This file defines several docker images. In order to use an image,
# build its derivation with `nix-build`, and then load the result with
# `docker load`. For example:
#
#  $ nix-build '<nixpkgs>' -A dockerTools.examples.redis
#  $ docker load < result

{ pkgs, buildImage, buildLayeredImage, fakeNss, pullImage, shadowSetup, buildImageWithNixDb, pkgsCross }:

rec {
  # 1. basic example
  bash = buildImage {
    name = "bash";
    tag = "latest";
    contents = pkgs.bashInteractive;
  };

  # 2. service example, layered on another image
  redis = buildImage {
    name = "redis";
    tag = "latest";

    # for example's sake, we can layer redis on top of bash or debian
    fromImage = bash;
    # fromImage = debian;

    contents = pkgs.redis;
    runAsRoot = ''
      mkdir -p /data
    '';

    config = {
      Cmd = [ "/bin/redis-server" ];
      WorkingDir = "/data";
      Volumes = {
        "/data" = {};
      };
    };
  };

  # 3. another service example
  nginx = let
    nginxPort = "80";
    nginxConf = pkgs.writeText "nginx.conf" ''
      user nobody nobody;
      daemon off;
      error_log /dev/stdout info;
      pid /dev/null;
      events {}
      http {
        access_log /dev/stdout;
        server {
          listen ${nginxPort};
          index index.html;
          location / {
            root ${nginxWebRoot};
          }
        }
      }
    '';
    nginxWebRoot = pkgs.writeTextDir "index.html" ''
      <html><body><h1>Hello from NGINX</h1></body></html>
    '';
  in
  buildLayeredImage {
    name = "nginx-container";
    tag = "latest";
    contents = [
      fakeNss
      pkgs.nginx
    ];

    extraCommands = ''
      # nginx still tries to read this directory even if error_log
      # directive is specifying another file :/
      mkdir -p var/log/nginx
      mkdir -p var/cache/nginx
    '';

    config = {
      Cmd = [ "nginx" "-c" nginxConf ];
      ExposedPorts = {
        "${nginxPort}/tcp" = {};
      };
    };
  };

  # 4. example of pulling an image. could be used as a base for other images
  nixFromDockerHub = pullImage {
    imageName = "nixos/nix";
    imageDigest = "sha256:85299d86263a3059cf19f419f9d286cc9f06d3c13146a8ebbb21b3437f598357";
    sha256 = "19fw0n3wmddahzr20mhdqv6jkjn1kanh6n2mrr08ai53dr8ph5n7";
    finalImageTag = "2.2.1";
    finalImageName = "nix";
  };
  # Same example, but re-fetches every time the fetcher implementation changes.
  # NOTE: Only use this for testing, or you'd be wasting a lot of time, network and space.
  testNixFromDockerHub = pkgs.invalidateFetcherByDrvHash pullImage {
    imageName = "nixos/nix";
    imageDigest = "sha256:85299d86263a3059cf19f419f9d286cc9f06d3c13146a8ebbb21b3437f598357";
    sha256 = "19fw0n3wmddahzr20mhdqv6jkjn1kanh6n2mrr08ai53dr8ph5n7";
    finalImageTag = "2.2.1";
    finalImageName = "nix";
  };

  # 5. example of multiple contents, emacs and vi happily coexisting
  editors = buildImage {
    name = "editors";
    contents = [
      pkgs.coreutils
      pkgs.bash
      pkgs.emacs
      pkgs.vim
      pkgs.nano
    ];
  };

  # 6. nix example to play with the container nix store
  # docker run -it --rm nix nix-store -qR $(nix-build '<nixpkgs>' -A nix)
  nix = buildImageWithNixDb {
    name = "nix";
    tag = "latest";
    contents = [
      # nix-store uses cat program to display results as specified by
      # the image env variable NIX_PAGER.
      pkgs.coreutils
      pkgs.nix
      pkgs.bash
    ];
    config = {
      Env = [
        "NIX_PAGER=cat"
        # A user is required by nix
        # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
        "USER=nobody"
      ];
    };
  };

  # 7. example of adding something on top of an image pull by our
  # dockerTools chain.
  onTopOfPulledImage = buildImage {
    name = "onTopOfPulledImage";
    tag = "latest";
    fromImage = nixFromDockerHub;
    contents = [ pkgs.hello ];
  };

  # 8. regression test for erroneous use of eval and string expansion.
  # See issue #34779 and PR #40947 for details.
  runAsRootExtraCommands = pkgs.dockerTools.buildImage {
    name = "runAsRootExtraCommands";
    tag = "latest";
    contents = [ pkgs.coreutils ];
    # The parens here are to create problematic bash to embed and eval. In case
    # this is *embedded* into the script (with nix expansion) the initial quotes
    # will close the string and the following parens are unexpected
    runAsRoot = ''echo "(runAsRoot)" > runAsRoot'';
    extraCommands = ''echo "(extraCommand)" > extraCommands'';
  };

  # 9. Ensure that setting created to now results in a date which
  # isn't the epoch + 1
  unstableDate = pkgs.dockerTools.buildImage {
    name = "unstable-date";
    tag = "latest";
    contents = [ pkgs.coreutils ];
    created = "now";
  };

  # 10. Create a layered image
  layered-image = pkgs.dockerTools.buildLayeredImage {
    name = "layered-image";
    tag = "latest";
    extraCommands = ''echo "(extraCommand)" > extraCommands'';
    config.Cmd = [ "${pkgs.hello}/bin/hello" ];
    contents = [ pkgs.hello pkgs.bash pkgs.coreutils ];
  };

  # 11. Create an image on top of a layered image
  layered-on-top = pkgs.dockerTools.buildImage {
    name = "layered-on-top";
    tag = "latest";
    fromImage = layered-image;
    extraCommands = ''
      mkdir ./example-output
      chmod 777 ./example-output
    '';
    config = {
      Env = [ "PATH=${pkgs.coreutils}/bin/" ];
      WorkingDir = "/example-output";
      Cmd = [
        "${pkgs.bash}/bin/bash" "-c" "echo hello > foo; cat foo"
      ];
    };
  };

  # 12 Create a layered image on top of a layered image
  layered-on-top-layered = pkgs.dockerTools.buildLayeredImage {
    name = "layered-on-top-layered";
    tag = "latest";
    fromImage = layered-image;
    extraCommands = ''
      mkdir ./example-output
      chmod 777 ./example-output
    '';
    config = {
      Env = [ "PATH=${pkgs.coreutils}/bin/" ];
      WorkingDir = "/example-output";
      Cmd = [
        "${pkgs.bash}/bin/bash" "-c" "echo hello > foo; cat foo"
      ];
    };
  };

  # 13. example of running something as root on top of a parent image
  # Regression test related to PR #52109
  runAsRootParentImage = buildImage {
    name = "runAsRootParentImage";
    tag = "latest";
    runAsRoot = "touch /example-file";
    fromImage = bash;
  };

  # 14. example of 3 layers images This image is used to verify the
  # order of layers is correct.
  # It allows to validate
  # - the layer of parent are below
  # - the order of parent layer is preserved at image build time
  #   (this is why there are 3 images)
  layersOrder = let
    l1 = pkgs.dockerTools.buildImage {
      name = "l1";
      tag = "latest";
      extraCommands = ''
        mkdir -p tmp
        echo layer1 > tmp/layer1
        echo layer1 > tmp/layer2
        echo layer1 > tmp/layer3
      '';
    };
    l2 = pkgs.dockerTools.buildImage {
      name = "l2";
      fromImage = l1;
      tag = "latest";
      extraCommands = ''
        mkdir -p tmp
        echo layer2 > tmp/layer2
        echo layer2 > tmp/layer3
      '';
    };
  in pkgs.dockerTools.buildImage {
    name = "l3";
    fromImage = l2;
    tag = "latest";
    contents = [ pkgs.coreutils ];
    extraCommands = ''
      mkdir -p tmp
      echo layer3 > tmp/layer3
    '';
  };

  # 15. Environment variable inheritance.
  # Child image should inherit parents environment variables,
  # optionally overriding them.
  environmentVariablesParent = pkgs.dockerTools.buildImage {
    name = "parent";
    tag = "latest";
    config = {
      Env = [
        "FROM_PARENT=true"
        "LAST_LAYER=parent"
      ];
    };
  };

  environmentVariables = pkgs.dockerTools.buildImage {
    name = "child";
    fromImage = environmentVariablesParent;
    tag = "latest";
    contents = [ pkgs.coreutils ];
    config = {
      Env = [
        "FROM_CHILD=true"
        "LAST_LAYER=child"
      ];
    };
  };

  environmentVariablesLayered = pkgs.dockerTools.buildLayeredImage {
    name = "child";
    fromImage = environmentVariablesParent;
    tag = "latest";
    contents = [ pkgs.coreutils ];
    config = {
      Env = [
        "FROM_CHILD=true"
        "LAST_LAYER=child"
      ];
    };
  };

  # 16. Create another layered image, for comparing layers with image 10.
  another-layered-image = pkgs.dockerTools.buildLayeredImage {
    name = "another-layered-image";
    tag = "latest";
    config.Cmd = [ "${pkgs.hello}/bin/hello" ];
  };

  # 17. Create a layered image with only 2 layers
  two-layered-image = pkgs.dockerTools.buildLayeredImage {
    name = "two-layered-image";
    tag = "latest";
    config.Cmd = [ "${pkgs.hello}/bin/hello" ];
    contents = [ pkgs.bash pkgs.hello ];
    maxLayers = 2;
  };

  # 18. Create a layered image with more packages than max layers.
  # coreutils and hello are part of the same layer
  bulk-layer = pkgs.dockerTools.buildLayeredImage {
    name = "bulk-layer";
    tag = "latest";
    contents = with pkgs; [
      coreutils hello
    ];
    maxLayers = 2;
  };

  # 19. Create a layered image with a base image and more packages than max
  # layers. coreutils and hello are part of the same layer
  layered-bulk-layer = pkgs.dockerTools.buildLayeredImage {
    name = "layered-bulk-layer";
    tag = "latest";
    fromImage = two-layered-image;
    contents = with pkgs; [
      coreutils hello
    ];
    maxLayers = 4;
  };

  # 20. Create a "layered" image without nix store layers. This is not
  # recommended, but can be useful for base images in rare cases.
  no-store-paths = pkgs.dockerTools.buildLayeredImage {
    name = "no-store-paths";
    tag = "latest";
    extraCommands = ''
      # This removes sharing of busybox and is not recommended. We do this
      # to make the example suitable as a test case with working binaries.
      cp -r ${pkgs.pkgsStatic.busybox}/* .
    '';
  };

  nixLayered = pkgs.dockerTools.buildLayeredImageWithNixDb {
    name = "nix-layered";
    tag = "latest";
    contents = [
      # nix-store uses cat program to display results as specified by
      # the image env variable NIX_PAGER.
      pkgs.coreutils
      pkgs.nix
      pkgs.bash
    ];
    config = {
      Env = [
        "NIX_PAGER=cat"
        # A user is required by nix
        # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
        "USER=nobody"
      ];
    };
  };

  # 21. Support files in the store on buildLayeredImage
  # See: https://github.com/NixOS/nixpkgs/pull/91084#issuecomment-653496223
  filesInStore = pkgs.dockerTools.buildLayeredImageWithNixDb {
    name = "file-in-store";
    tag = "latest";
    contents = [
      pkgs.coreutils
      pkgs.nix
      (pkgs.writeScriptBin "myscript" ''
        #!${pkgs.runtimeShell}
        cat ${pkgs.writeText "somefile" "some data"}
      '')
    ];
    config = {
      Cmd = [ "myscript" ];
      # For some reason 'nix-store --verify' requires this environment variable
      Env = [ "USER=root" ];
    };
  };

  # 22. Ensure that setting created to now results in a date which
  # isn't the epoch + 1 for layered images.
  unstableDateLayered = pkgs.dockerTools.buildLayeredImage {
    name = "unstable-date-layered";
    tag = "latest";
    contents = [ pkgs.coreutils ];
    created = "now";
  };

  # buildImage without explicit tag
  bashNoTag = pkgs.dockerTools.buildImage {
    name = "bash-no-tag";
    contents = pkgs.bashInteractive;
  };

  # buildLayeredImage without explicit tag
  bashNoTagLayered = pkgs.dockerTools.buildLayeredImage {
    name = "bash-no-tag-layered";
    contents = pkgs.bashInteractive;
  };

  # buildImage without explicit tag
  bashNoTagStreamLayered = pkgs.dockerTools.streamLayeredImage {
    name = "bash-no-tag-stream-layered";
    contents = pkgs.bashInteractive;
  };

  # buildLayeredImage with non-root user
  bashLayeredWithUser =
  let
    nonRootShadowSetup = { user, uid, gid ? uid }: with pkgs; [
      (
      writeTextDir "etc/shadow" ''
        root:!x:::::::
        ${user}:!:::::::
      ''
      )
      (
      writeTextDir "etc/passwd" ''
        root:x:0:0::/root:${runtimeShell}
        ${user}:x:${toString uid}:${toString gid}::/home/${user}:
      ''
      )
      (
      writeTextDir "etc/group" ''
        root:x:0:
        ${user}:x:${toString gid}:
      ''
      )
      (
      writeTextDir "etc/gshadow" ''
        root:x::
        ${user}:x::
      ''
      )
    ];
  in
    pkgs.dockerTools.buildLayeredImage {
      name = "bash-layered-with-user";
      tag = "latest";
      contents = [ pkgs.bash pkgs.coreutils ] ++ nonRootShadowSetup { uid = 999; user = "somebody"; };
    };

  # basic example, with cross compilation
  cross = let
    # Cross compile for x86_64 if on aarch64
    crossPkgs =
      if pkgs.system == "aarch64-linux" then pkgsCross.gnu64
      else pkgsCross.aarch64-multiplatform;
  in crossPkgs.dockerTools.buildImage {
    name = "hello-cross";
    tag = "latest";
    contents = crossPkgs.hello;
  };

  # layered image where a store path is itself a symlink
  layeredStoreSymlink =
  let
    target = pkgs.writeTextDir "dir/target" "Content doesn't matter.";
    symlink = pkgs.runCommand "symlink" {} "ln -s ${target} $out";
  in
    pkgs.dockerTools.buildLayeredImage {
      name = "layeredstoresymlink";
      tag = "latest";
      contents = [ pkgs.bash symlink ];
    } // { passthru = { inherit symlink; }; };

  # image with registry/ prefix
  prefixedImage = pkgs.dockerTools.buildImage {
    name = "registry-1.docker.io/image";
    tag = "latest";
    config.Cmd = [ "${pkgs.hello}/bin/hello" ];
  };

  # layered image with registry/ prefix
  prefixedLayeredImage = pkgs.dockerTools.buildLayeredImage {
    name = "registry-1.docker.io/layered-image";
    tag = "latest";
    config.Cmd = [ "${pkgs.hello}/bin/hello" ];
  };

  # layered image with files owned by a user other than root
  layeredImageWithFakeRootCommands = pkgs.dockerTools.buildLayeredImage {
    name = "layered-image-with-fake-root-commands";
    tag = "latest";
    contents = [
      pkgs.pkgsStatic.busybox
    ];
    fakeRootCommands = ''
      mkdir -p ./home/jane
      chown 1000 ./home/jane
    '';
  };

  # tarball consisting of both bash and redis images
  mergedBashAndRedis = pkgs.dockerTools.mergeImages [
    bash
    redis
  ];

  # tarball consisting of bash (without tag) and redis images
  mergedBashNoTagAndRedis = pkgs.dockerTools.mergeImages [
    bashNoTag
    redis
  ];

  # tarball consisting of bash and layered image with different owner of the
  # /home/jane directory
  mergedBashFakeRoot = pkgs.dockerTools.mergeImages [
    bash
    layeredImageWithFakeRootCommands
  ];

  helloOnRoot = pkgs.dockerTools.streamLayeredImage {
    name = "hello";
    tag = "latest";
    contents = [
      (pkgs.buildEnv {
        name = "hello-root";
        paths = [ pkgs.hello ];
      })
    ];
    config.Cmd = [ "hello" ];
  };

  helloOnRootNoStore = pkgs.dockerTools.streamLayeredImage {
    name = "hello";
    tag = "latest";
    contents = [
      (pkgs.buildEnv {
        name = "hello-root";
        paths = [ pkgs.hello ];
      })
    ];
    config.Cmd = [ "hello" ];
    includeStorePaths = false;
  };

  # Example export of the bash image
  exportBash = pkgs.dockerTools.exportImage { fromImage = bash; };

  build-image-with-path = buildImage {
    name = "build-image-with-path";
    tag = "latest";
    contents = [ pkgs.bashInteractive ./test-dummy ];
  };

  layered-image-with-path = pkgs.dockerTools.streamLayeredImage {
    name = "layered-image-with-path";
    tag = "latest";
    contents = [ pkgs.bashInteractive ./test-dummy ];
  };
}
