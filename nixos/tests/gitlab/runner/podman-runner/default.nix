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

  # This derivation will contain a folder `/etc`
  files = pkgs.callPackage ./files { };
  preBuildScript = pkgs.callPackage ./scripts/prebuild.nix { };

  # These derivations are Linked into the job images root dir.
  bootstrapPkgs = [
    pkgs.nix
    # Runtime dependencies of nix.
    pkgs.gnutar
    pkgs.gzip
    pkgs.openssh
    pkgs.xz
    pkgs.cacert

    # Other stuff.
    (lib.hiPrio pkgs.coreutils)
    (lib.hiPrio pkgs.findutils)
    pkgs.openssh
    pkgs.bashInteractive
    (lib.hiPrio pkgs.git)
    pkgs.cachix

    pkgs.just
    pkgs.podman # For nested containers.

    preBuildScript

    files.containers
    files.nixConfig
  ];

  # All these packages are added to the Nix daemon.
  nixStorePkgs = bootstrapPkgs ++ [
    # These files
    files.basicRoot
    files.fakeNixpkgs
  ];

  toEnvList = envs: lib.mapAttrsToList (k: v: "${k}=${v}") envs;

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
          rev = "2.32.4";
          hash = "sha256-8QYnRyGOTm3h/Dp8I6HCmQzlO7C009Odqyp28pTWgcY=";
        })
        + "/docker.nix"
      );

  nixImageBase = pkgs.callPackage nixImageBaseFn {
    name = "local/nix-base";
    tag = "latest";

    bundleNixpkgs = false;
    maxLayers = 2;

    # You can add here a user with uid,gid,uname,gname etc.
    # We are using root.

    extraPkgs = nixStorePkgs;

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

  jobImages =
    let
      extraCommands = ''
        set -eu
        # Set missing Nix directories.
        mkdir -p -m 0755 nix/var/log/nix/drvs
        mkdir -p -m 0755 nix/var/nix/{gcroots,profiles,temproots,userpool}
        mkdir -p -m 1777 nix/var/nix/{gcroots,profiles}/per-user
        mkdir -p -m 0755 nix/var/nix/profiles/per-user/root

        # Need a HOME.
        mkdir -vp root
        mkdir -p -m 0700 root/.nix-defexpr
      '';
    in
    {
      # The Nix image.
      # Similar to https://github.com/nix-community/docker-nixpkgs/blob/main/images/nix/default.nix.
      nix = pkgs.dockerTools.buildLayeredImage {
        name = imageNames.nix;
        tag = "latest";

        extraCommands = extraCommands + ''
          set -eu
          # For `/usr/bin/env`.
          mkdir -p usr && ln -s ../bin usr/bin
        '';

        contents = bootstrapPkgs ++ [ files.basicRoot ];
        # No store paths are copied into. We provide them by mounting the
        # /nix/store.
        includeStorePaths = false;

        config = {
          Labels = noPruneLabels;
          Env = toEnvList envs.nix;
        };
        maxLayers = 2;
      };

      # This is the analog image to `local/nix` but Alpine based.
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

          inherit extraCommands;

          contents = bootstrapPkgs;
          # No store paths are copied into. We provide them by mounting the
          # /nix/store.
          includeStorePaths = false;

          config = {
            Labels = noPruneLabels;
            Env = toEnvList envs.nix;
          };

          # Only if `build buildLayeredImage`.
          maxLayers = 3;
        });

      # This is the analog image to `local/nix` but Ubuntu based.
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

          inherit extraCommands;

          contents = bootstrapPkgs;
          # No store paths are copied into. We provide them by mounting the
          # /nix/store.
          includeStorePaths = false;

          config = {
            Labels = noPruneLabels;
            Env = toEnvList envs.ubuntu;
          };

          # Only if `build buildLayeredImage`.
          maxLayers = 3;
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
    common = {
      # Access to the nix daemon.
      NIX_REMOTE = "daemon";
      # Access to podman.
      CONTAINER_HOST = "unix:///run/podman/podman.sock";

      USER = "root";
      PATH = "/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin";

      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

      # For shells, source this file.
      ENV = "${pkgs.nix}/etc/profile.d/nix-daemon.sh";
      BASH_ENV = "${pkgs.nix}/etc/profile.d/nix-daemon.sh";

      # Make a fake nixpkgs which throws when using
      # `nix repl -f <nixpkgs>` for example.
      NIX_PATH = "nixpkgs=${files.fakeNixpkgs}";
    };

    nix = common // {
      IMAGE_OS_DIST = "nix";
    };

    alpine = common // {
      IMAGE_OS_DIST = "alpine";
    };

    ubuntu = common // {
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
        "${name}-container" = {
          imageFile = jobImages.${name};
          image = "${imageNames.${name}}:latest";
          extraOptions = [
            "--volumes-from"
            "nix-daemon-container:ro"
          ];
          dependsOn = [ "nix-daemon-container" ];
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
