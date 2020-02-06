# Examples of using the docker tools to build packages.
#
# This file defines several docker images. In order to use an image,
# build its derivation with `nix-build`, and then load the result with
# `docker load`. For example:
#
#  $ nix-build '<nixpkgs>' -A dockerTools.examples.redis
#  $ docker load < result

{ pkgs, buildImage, pullImage, shadowSetup, buildImageWithNixDb }:

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
      user nginx nginx;
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
  buildImage {
    name = "nginx-container";
    tag = "latest";
    contents = pkgs.nginx;

    runAsRoot = ''
      #!${pkgs.stdenv.shell}
      ${shadowSetup}
      groupadd --system nginx
      useradd --system --gid nginx nginx
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
    sha256 = "07q9y9r7fsd18sy95ybrvclpkhlal12d30ybnf089hq7v1hgxbi7";
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

  # 12. example of running something as root on top of a parent image
  # Regression test related to PR #52109
  runAsRootParentImage = buildImage {
    name = "runAsRootParentImage";
    tag = "latest";
    runAsRoot = "touch /example-file";
    fromImage = bash;
  };

  # 13. example of 3 layers images This image is used to verify the
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

  # 14. Create another layered image, for comparing layers with image 10.
  another-layered-image = pkgs.dockerTools.buildLayeredImage {
    name = "another-layered-image";
    tag = "latest";
    config.Cmd = [ "${pkgs.hello}/bin/hello" ];
  };

  # 15. Create a layered image with only 2 layers
  two-layered-image = pkgs.dockerTools.buildLayeredImage {
    name = "two-layered-image";
    tag = "latest";
    config.Cmd = [ "${pkgs.hello}/bin/hello" ];
    contents = [ pkgs.bash pkgs.hello ];
    maxLayers = 2;
  };
}
