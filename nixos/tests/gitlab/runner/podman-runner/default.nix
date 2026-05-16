{ runnerConfig }:
# Gitlab Runner Module
#
# This module will add a Gitlab-Runner
# with a nix-daemon running in a podman container `nix-daemon-container`.
# Check the documentation in the NixOS Manual.
#
# Debugging on the VM:
#
# - You can use `journalctl -u gitlab-runner.service`.
#
# - To run a job container inside the VM use:
#   ```bash
#      podman run --rm -it
#      --volumes-from 'nix-daemon-container'
#      -v "podman-daemon-socket:/run/podman"
#      "local/alpine" \
#      bash -c "export CI_PIPELINE_ID=123456 && gitlab-runner-pre-build-script; echo hello"
#   ```
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Switch to not use IFD in nixpkgs test.
  # NOTE: When reusing this runner, you can set this to `true`.
  useIFD = false;

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

  # Some scripts we use.
  updateNixStoreVolume = pkgs.callPackage ./scripts/copy-to-nix-store.nix {
    image = nixDaemonImage.imageName + ":" + nixDaemonImage.imageTag;
    imageDrv = nixDaemonImage;
  };

  # These derivations are symlinked into the job images root dir.
  jobImgs = import ./job-images.nix {
    inherit
      lib
      pkgs
      noPruneLabels
      imageNames
      ;
  };

  # This is the Nix base image used for the Nix Daemon.
  # The build script for the nixos/nix image is vendored due to Hydra limitations.
  # cause it is IFD (Import from Derivation) which is not allowed.
  # NOTE: When reusing this runner you can set `useIFD` to true:
  nixImageBaseFn =
    if !useIFD then
      import ./nix-image.nix
    else
      import (
        (pkgs.fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          rev = "2.34.7";
          hash = "sha256-8QYnRyGOTm3h/Dp8I6HCmQzlO7C009Odqyp28pTWgcY=";
        })
        + "/docker.nix"
      );

  nixDaemonImageBase = pkgs.callPackage nixImageBaseFn {
    name = "local/nix-base";
    tag = "latest";

    bundleNixpkgs = false;
    maxLayers = 2;

    # You can add here a user with uid,gid,uname,gname etc.
    # We are using root.
    extraPkgs = jobImgs.allStoreDrv;

    nixConf = {
      cores = "0";
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # TODO: Make here a signing key.
      # secret-key-files = [ config.sops.secrets.nix-store-signing-key.path ];

      min-free = "1G"; # Triggers garbage collection.
      max-free = "100G"; # Stops garbage collection at 100G free space.

      # # Reduce disk usage by discarding old derivations/outputs
      # keep-derivations = false;
      # keep-outputs = false;
    };
  };

  # This is the daemon image which provides the store
  # as volumes.
  nixDaemonImage = pkgs.dockerTools.buildLayeredImage {
    fromImage = nixDaemonImageBase;
    name = "local/nix-daemon";
    tag = "latest";

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

  nixDaemonContainer = {
    imageFile = nixDaemonImage;
    image = "local/nix-daemon:latest";

    volumes = [
      "nix-daemon-store:/nix/store"
      "nix-daemon-db:/nix/var/nix/db"
      "nix-daemon-socket:/nix/var/nix/daemon-socket"
      # TODO: Add signing key.
      # "${config.sops.secrets.nix-store-signing-key.path}:${config.sops.secrets.nix-store-signing-key.path}:ro"
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
    "bridge"
  ];

  # Define the containers for the jobs.
  # This is a trick to add the job images to the registry.
  # TODO: Can this be done better?
  # On `nix` also make the scratch directory world readable.
  jobContainers = (
    lib.concatMapAttrs (name: image: {
      "${name}-container" = {
        imageFile = jobImgs.images.${name};
        image = "${imageNames.${name}}:latest";

        extraOptions = [
          "--volumes-from"
          "nix-daemon-container:ro"
        ];

        dependsOn = [ "nix-daemon-container" ];
        cmd = [ "true" ];
      }
      // (lib.optionalAttrs (name == "nix") {
        volumes = [ "gitlab-runner-scratch:/scratch" ];
        cmd = [
          "chmod"
          "777"
          "/scratch"
        ];
      });
    }) jobImgs.images
  );

  # Do not restart systemd service for the job images.
  # Otherwise they get readded always.
  modifiedJobServices = lib.concatMapAttrs (
    name: image:
    let
      serviceName = config.virtualisation.oci-containers.containers."${name}-container".serviceName;
    in
    {
      "${serviceName}".serviceConfig = {
        Restart = lib.mkForce "no";
      };
    }
  ) jobImgs.images;
in
{
  imports = [ ./virtualization.nix ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers = jobContainers // {
      nix-daemon-container = nixDaemonContainer;
      podman-daemon-container = podmanDaemonContainer;
    };
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

    preBuildScript = "${lib.getExe jobImgs.preBuildScript}";
  };

  systemd.services = modifiedJobServices // {
    # Update Nix store in the daemon service.
    # The job images do not contain any actual store paths and are very small.
    # We add `allStoreDrvs` to the nix store volume `nix-daemon-store` of the
    # `nixDaemonImageBase` to make everything available on the job images
    # (they mount `nix-daemon-store`).
    # But when you delete the volume for cleanup or space reasons, this
    # service initializes the store correctly again.
    # Note: Podman, when starting the `nix-daemon-container`, copies all `/nix/store` paths
    # from the image to the `nix-daemon-store` volume before running it.
    update-nix-daemon-store = {
      description = "update-nix-daemon-store";
      restartIfChanged = true;
      wantedBy = [ "multi-user.target" ];

      # Ensure that the bootstrap is restarted when `nix-daemon-container` is.
      partOf = [ "podman-nix-daemon-container.service" ];

      script = ''
        ${lib.getExe updateNixStoreVolume}
      '';

      serviceConfig = {
        Type = "oneshot";
        SupplementaryGroups = "podman";
        User = "root";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    # Start 'nix-daemon-container' after the update of the volume.
    podman-nix-daemon-container.after = [ "update-nix-daemon-store.service" ];
    # Start Runner after nix-daemon-container.
    gitlab-runner.after = [ "podman-nix-daemon-container.service" ];
  };
}
