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
    imageDigest = "sha256:20d9485b25ecfd89204e843a962c1bd70e9cc6858d65d7f5fadc340246e2116b";
    sha256 = "0mqjy3zq2v6rrhizgb9nvhczl87lcfphq9601wcprdika2jz7qh8";
    finalImageTag = "1.11";
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
      Env = [ "NIX_PAGER=cat" ];
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
}
