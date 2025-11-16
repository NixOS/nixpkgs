{
  lib,
  pkgs,
  ...
}:
let
  fs = lib.fileset;

  # Get the repository for Nix for building the Nix image.
  nix = builtins.fetchGit {
    url = "https://github.com/NixOS/nix.git";
    ref = "master";
  };

  # Either we use a Nix as the base image or Alpine.
  jobImageNames = {
    default = jobImageNames.alpine;

    nix = "local/nix";
    alpine = "local/alpine";
    ubuntu = "local/ubuntu";

    all = with jobImageNames; [
      alpine
      nix
      ubuntu
    ];
  };

  noPruneLabels = {
    no-prune = "true";
  };

  # This derivation will contain a folder `/etc`
  # If its added to `contents` all files in the
  # derivation will be symlinked in `/`.
  # NOTE: You need to run `nix run -f get-podman-config-files.nix`
  auxRootFiles = fs.toSource {
    root = ./root;
    fileset = fs.gitTracked ./root/etc;
  };

  # The prebuild script which is run before every job.
  preBuildScript = pkgs.callPackage ./scripts/runner-prebuild-script.nix { };

  # Bootstrap packages which should always be in the `/nix/store`.
  bootstrapPkgs = [
    pkgs.nix
    pkgs.cacert
    (lib.hiPrio pkgs.coreutils)
    pkgs.findutils
    (lib.hiPrio pkgs.git)
    pkgs.openssh
    pkgs.bash
  ];

  toEnvList = envs: lib.mapAttrsToList (k: v: "${k}=${v}") envs;

  # This is the Nix base image.
  nixImageBase = pkgs.callPackage (import (nix.outPath + "/docker.nix")) {
    name = "local/nix-base";
    tag = "latest";

    bundleNixpkgs = false;
    maxLayers = 2;

    # You can add here a user with uid,gid,uname,gname etc.
    # We are using root.

    # The Nix store needs all packages which we have as content
    # packages in the base images.
    # The Nix store is mounted into the base image.
    extraPkgs = bootstrapPkgs;

    nixConf = {
      cores = "0";
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # This is the daemon image which provides the store as volumes.
  nixDaemonImage = pkgs.dockerTools.buildLayeredImage {
    fromImage = nixImageBase;
    name = "local/nix-daemon";
    tag = "latest";

    contents = [ auxRootFiles ];

    config = {
      Volumes = {
        "/nix/store" = { };
        "/nix/var/nix/db" = { };
        "/nix/var/nix/daemon-socket" = { };
      };
      Labels = noPruneLabels;
    };
    maxLayers = 5;
  };

  jobImages = {
    # The Nix base image for jobs.
    nix = pkgs.dockerTools.buildLayeredImage {
      fromImage = nixImageBase;
      name = jobImageNames.nix;
      tag = "latest";

      contents = bootstrapPkgs ++ [ auxRootFiles ];

      config = {
        Labels = noPruneLabels;
        Env = toEnvList envs.nix;
      };
      maxLayers = 4;
    };

    # The Alpine base image for jobs.
    # This is the analog image to `local/nix` but alpine based.
    alpine = (
      let
        # Update with:
        # `shell
        # nix run "github:nixos/nixpkgs/nixos-unstable#nix-prefetch-docker" -- \
        #   --image-name alpine --image-tag latest
        # `
        alpineBase = pkgs.dockerTools.pullImage {
          imageName = "alpine";
          imageDigest = "sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1";
          hash = "sha256-1Af8p6cYQs8sxlowz4BC6lC9eAOpNWYnIhCN7BSDKL0=";
          finalImageName = "alpine";
          finalImageTag = "latest";
        };
      in
      pkgs.dockerTools.buildLayeredImage {
        fromImage = alpineBase;
        name = jobImageNames.alpine;
        tag = "latest";

        # We need these packages in the container, to create the symlinks
        # TODO: How to only keep the symlink and strip everything from /nix/store
        # because it anyway gets overmounted.
        contents = bootstrapPkgs ++ [ auxRootFiles ];

        config = {
          Labels = noPruneLabels;
          Env = toEnvList envs.alpine;
        };

        # Only if `build buildLayeredImage`.
        maxLayers = 15;
      }
    );

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
          imageDigest = "sha256:9cbed754112939e914291337b5e554b07ad7c392491dba6daf25eef1332a22e8";
          hash = "sha256-h9nSeiUrM6quWG0fpl1gH2vw2Jvh7k0yfapvcoIQ4rc=";
          finalImageName = "ubuntu";
          finalImageTag = "latest";
        };
      in
      (pkgs.dockerTools.buildLayeredImage {
        fromImage = ubuntuBase;
        name = jobImageNames.ubuntu;
        tag = "latest";

        # We need these packages in the container, to create the symlinks in `/bin/...`.
        # TODO: How to only keep the symlink and strip everything from /nix/store
        # because it anyway gets overmounted.
        contents = bootstrapPkgs ++ [ auxRootFiles ];

        config = {
          Labels = noPruneLabels;
          Env = toEnvList envs.ubuntu;
        };

        # Only if `build buildLayeredImage`.
        maxLayers = 15;
      });
  };

  # The daemon container.
  nixDaemonContainer = {
    imageFile = nixDaemonImage;
    image = "local/nix-daemon:latest";
    # I cannot denote these volumes because they overmount the
    # shit which is in the image.
    # TODO: make a systemd service which starts before
    # that and creates some volumes and inits these from the image.
    # volumes = [
    #   "nix-daemon-store:/nix/store"
    #   "nix-daemon-db:/nix/var/nix/db"
    #   "nix-daemon-socket:/nix/var/nix/daemon-socket"
    # ];
    cmd = [
      "nix"
      "daemon"
    ];
  };

  # Environment variables for the containers.
  envs = rec {
    nix = {
      IMAGE_OS_DIST = "nixos";
      NIX_REMOTE = "daemon";
    };

    alpine = {
      IMAGE_OS_DIST = "alpine";

      NIX_REMOTE = "daemon";
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
    "gitlab-runner-cache:/scratch"
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
  # Common containers settings.
  virtualisation.containers.storage.settings = {
    storage = {
      driver = "overlay";
      graphroot = "/var/lib/containers/storage";
      runroot = "/run/containers/storage";

      options.overlay = {
        mountopt = "nodev,metacopy=on";
      };
    };
  };

  # Common OCI container which should run.
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      nix-daemon-container = nixDaemonContainer;
    }
    //
      # Workaround to add the job images to the registry.
      lib.concatMapAttrs (name: image: {
        "${name}-container" = {
          imageFile = jobImages.${name};
          image = "${jobImageNames.${name}}:latest";
          cmd = [ "true" ];
        };
      }) jobImages;
  };

  # Define the Gitlab Runner.
  services.gitlab-runner = {
    enable = true;

    settings = {
      log_level = "info";
      concurrent = 32;
      check_interval = 2;
    };

    gracefulTermination = false;

    services.nix-runner = {
      description = "Nix Runner (NixOS)";
      inherit registrationFlags;
      authenticationTokenConfigFile = "/run/secrets/gitlab-runner/nix-runner-token.env";

      executor = "docker";
      dockerImage = jobImageNames.default;
      dockerAllowedImages = [ ];
      dockerPrivileged = false;
      requestConcurrency = 4;

      preBuildScript = "${preBuildScript}/bin/gitlab-runner-pre-build-script";
    };
  };
}
