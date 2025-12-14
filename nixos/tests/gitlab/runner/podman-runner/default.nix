{ runnerConfig }:
# Gitlab Runner Module
#
# This module will add a Gitlab-Runner
# configured similar to https://wiki.nixos.org/wiki/Gitlab_runner
# with a nix-daemon running in a podman container `nix-daemon-container`.
#
# - The volumes from the `nix-daemon-container` will get mounted to
#   each job container which Gitlab starts, which gives them access
#   to a commonly shared Nix store.
#
#   - The `/nix/store` inside the job container
#     (either image `alpineImage` or `ubuntuImage` or `nixImage`)
#     will be read-only and nix can only store stuff into this path by using the
#     `NIX_DAEMON` env. variable which lets it communicate through the
#     mounted daemon socket.

#   - The `bootstrapPkgs` derivation is copied into the job containers
#     but without the Nix store paths cause they get provided by the
#     `nix-daemon-store` volume.
#
# - The `podman-daemon-socket` volume gets mounted to the job container
#   enabling it to use `podman`.
#   Note: The job container instance is not using the system `podman` running in NixOS.
#   Its a dedicated podman service `podmanDaemonContainer`
#   running as `--privileged`
#   [non-rootless container](https://rootlesscontaine.rs/#what-are-rootless-containers-and-what-are-not).
#   (TODO: This podman daemon instance could be maybe run as rootless
#   container under a user `ci` and a separated Gitlab Runner could
#   run over this socket, effectively run only rootless containers.)
#
# - There is also a job runner prebuild script which is started on every job.
#   See `scripts/prebuild.nix` to setup some missing stuff.
#
# Debugging on the VM:
#
# - You can use `journalclt -u gitlab-runner.service`.
#
# - To run a job container use:
#   ```bash
#      podman run --rm -it
#      --volumes-from 'nix-daemon-container'
#      -v "podman-daemon-socket:/run/podman"
#      "local/alpine" \
#      bash -c "export CI_PIPkELINE_ID=123456 && gitlab-runner-prebuild-script; echo hello"
#   ```
{
  lib,
  pkgs,
  ...
}:
let
  nixRepo = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nix";
    rev = "2.32.4";
    hash = "sha256-8QYnRyGOTm3h/Dp8I6HCmQzlO7C009Odqyp28pTWgcY=";
  };

  # Either we use a Nix as the base image or Alpine.
  imageNames = {
    default = imageNames.alpine;

    alpine = "local/alpine";
    nix = "local/nix";
    ubuntu = "local/ubuntu";

    all = with imageNames; [
      alpine
      nix
      ubuntu
    ];
  };

  noPruneLabels = {
    no-prune = "true";
  };

  # This derivation will contain a folder `/etc`
  auxRootFiles = pkgs.callPackage ./root { };
  preBuildScript = pkgs.callPackage ./scripts/prebuild.nix { };

  bootstrapPkgs = [
    pkgs.nix
    pkgs.cacert
    (lib.hiPrio pkgs.coreutils)
    (lib.hiPrio pkgs.findutils)
    pkgs.openssh
    pkgs.bash
    (lib.hiPrio pkgs.git)
    pkgs.cachix

    pkgs.just
    pkgs.podman # For nested containers.

    preBuildScript
    auxRootFiles
  ];

  toEnvList = envs: lib.mapAttrsToList (k: v: "${k}=${v}") envs;

  # This is the Nix base image.
  nixImageBase = pkgs.callPackage (import (nixRepo + "/docker.nix")) {
    name = "local/nix-base";
    tag = "latest";

    bundleNixpkgs = false;
    maxLayers = 2;

    # You can add here a user with uid,gid,uname,gname etc.
    # We are using root.

    nixConf = {
      cores = "0";
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # This is the daemon image which provides the store
  # as volumes.
  nixDaemonImage = pkgs.dockerTools.buildLayeredImage {
    fromImage = nixImageBase;
    name = "local/nix-daemon";
    tag = "latest";

    contents = bootstrapPkgs;

    config = {
      Volumes = {
        "/nix/store" = { };
        "/nix/var/nix/db" = { };
        "/nix/var/nix/daemon-socket" = { };
      };
      Labels = noPruneLabels;
    };
    maxLayers = 4;
  };

  # This is the podman daemon image which enables
  # a job image to use `podman` internally.
  podmanDaemonImage =
    let
      # Update with:
      # ```shell
      # nix run "github:nixos/nixpkgs/nixos-unstable#nix-prefetch-docker" -- \
      #    --image-name quay.io/podman/stable --image-tag v5.6.0
      # ```
      base = pkgs.dockerTools.pullImage {
        imageName = "quay.io/podman/stable";
        imageDigest = "sha256:7c9381b9af167cf2218831c3af3135856c99f488b543b78435c8f18e19ad739a";
        hash = "sha256-pXXCu13fB/RN9qx8iLhE5Kko6glTrFrRhR7fo2OS7V0=";
        finalImageName = "quay.io/podman/stable";
        finalImageTag = "v5.6.0";
      };
    in
    pkgs.dockerTools.buildLayeredImage {
      fromImage = base;
      name = "local/podman-daemon";
      tag = "latest";

      config = {
        Labels = noPruneLabels;
      };
    };

  jobImages = {
    # The base image
    nix = pkgs.dockerTools.buildLayeredImage {
      fromImage = nixImageBase;
      name = imageNames.nix;
      tag = "latest";

      contents = bootstrapPkgs;
      # No store paths are copied into. We provide them by mounting the
      # /nix/store.
      includeStorePaths = false;

      config = {
        Labels = noPruneLabels;
        Env = toEnvList envs.nix;
      };
      maxLayers = 4;
    };

    # This is the analog image to `local/nix` but alpine based.
    alpine =
      let
        # Update with:
        # ```shell
        # nix run "github:nixos/nixpkgs/nixos-unstable#nix-prefetch-docker" -- --image-name alpine --image-tag latest
        # ```
        alpineBase = pkgs.dockerTools.pullImage {
          imageName = "alpine";
          imageDigest = "sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d";
          sha256 = "0gf7wbjp37zbni3pz8vdgq1mss6mz69wynms0gqhq7lsxfmg9xj9";
          finalImageName = "alpine";
          finalImageTag = "latest";
        };
      in
      (pkgs.dockerTools.buildLayeredImage {
        fromImage = alpineBase;
        name = imageNames.alpine;
        tag = "latest";

        contents = bootstrapPkgs;
        # No store paths are copied into. We provide them by mounting the
        # /nix/store.
        includeStorePaths = false;

        config = {
          Labels = noPruneLabels;
          Env = toEnvList envs.alpine;
        };

        # Only if `build buildLayeredImage`.
        maxLayers = 15;
      });

    # This is the analog image to `local/nix` but ubuntu based.
    ubuntu =
      let
        # Update with:
        # ```shell
        # nix run "github:nixos/nixpkgs/nixos-unstable#nix-prefetch-docker" -- \
        #   --image-name ubuntu --image-tag latest
        # ```
        ubuntuBase = pkgs.dockerTools.pullImage {
          imageName = "ubuntu";
          imageDigest = "sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02";
          hash = "sha256-aC8SgxdcMSaaU89YMr/uwE022Yqey2frmeZqr+L1xEU=";
          finalImageName = "ubuntu";
          finalImageTag = "latest";
        };
      in
      (pkgs.dockerTools.buildLayeredImage {
        fromImage = ubuntuBase;
        name = imageNames.ubuntu;
        tag = "latest";

        contents = bootstrapPkgs;
        # No store paths are copied into. We provide them by mounting the
        # /nix/store.
        includeStorePaths = false;

        config = {
          Labels = noPruneLabels;
          Env = toEnvList envs.ubuntu;
        };

        # Only if `build buildLayeredImage`.
        maxLayers = 15;
      });
  };

  nixDaemonContainer = {
    imageFile = nixDaemonImage;
    image = "local/nix-daemon:latest";

    volumes = [
      "nix-daemon-store:/nix/store"
      "nix-daemon-db:/nix/var/nix/db"
      "nix-daemon-socket:/nix/var/nix/daemon-socket"
    ];
    cmd = [
      "nix"
      "daemon"
    ];
  };

  podmanDaemonContainer = {
    imageFile = podmanDaemonImage;
    image = "local/podman-daemon:latest";
    volumes = [
      "podman-daemon-socket:/run/podman"
      "podman-cache:/var/lib/container"
      # Shared images, currently not needed.
      "podman-shared:/var/lib/shared:ro"
    ];
    privileged = true;
    cmd = [
      "podman"
      "system"
      "service"
      "--time=0"
      "unix:///run/podman/podman.sock"
      "--log-level"
      "info"
    ];
  };

  # Environment variables for all job containers.
  envs = rec {
    daemons = {
      # Access to the nix daemon.
      NIX_REMOTE = "daemon";
      # Access to podman.
      CONTAINER_HOST = "unix:///run/podman/podman.sock";
    };

    nix = daemons // {
      IMAGE_OS_DIST = "nixos";
    };

    alpine = daemons // {
      IMAGE_OS_DIST = "alpine";

      USER = "root";
      PATH = "/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin";
      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    };

    ubuntu = alpine // {
      IMAGE_OS_DIST = "ubuntu";
    };
  };

  registrationFlags = [
    "--docker-volumes"
    "gitlab-runner-scratch:/scratch"

    "--docker-volumes"
    "podman-daemon-socket:/run/podman"

    "--docker-volumes-from"
    "nix-daemon-container:ro"

    "--docker-pull-policy"
    "if-not-present"

    "--docker-allowed-pull-policies"
    "if-not-present"

    "--docker-host"
    "unix:///var/run/podman/podman.sock"

    "--docker-network-mode"
    "host"
  ];

in
{
  imports = [ ./virtualization.nix ];

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      nix-daemon-container = nixDaemonContainer;
      podman-daemon-container = podmanDaemonContainer;
    }
    //
      # Workaround to add the job images to the registry.
      (lib.concatMapAttrs (name: image: {
        "container-${name}" = {
          imageFile = jobImages.${name};
          image = "${imageNames.${name}}:latest";
          cmd = [ "true" ];
        };
      }) jobImages);
  };

  # Define the Gitlab Runner.
  services.gitlab-runner.services.podman-runner = {
    description = runnerConfig.desc;

    inherit registrationFlags;

    authenticationTokenConfigFile = runnerConfig.tokenFile;

    executor = "docker";
    dockerImage = imageNames.default;
    dockerAllowedImages = [ ];
    dockerPrivileged = false;
    requestConcurrency = 4;

    preBuildScript = "${preBuildScript}/bin/gitlab-runner-pre-build-script";
  };
}
