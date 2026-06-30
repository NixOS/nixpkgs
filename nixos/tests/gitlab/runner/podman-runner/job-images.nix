{
  lib,
  pkgs,
  noPruneLabels,
  imageNames,
}:
let
  # This derivation will contain a folder `/etc`
  files = pkgs.callPackage ./files { };
  initScripts = pkgs.callPackage ./scripts/init.nix { };
  preBuildScript = pkgs.callPackage ./scripts/prebuild.nix {
    profileScript = initScripts.profile;
  };

  toEnvList = envs: lib.mapAttrsToList (k: v: "${k}=${v}") envs;

  jobImagePkgs = [
    pkgs.nix
    pkgs.bash
    # Runtime dependencies of nix. (why I need to add these is not clear.)
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
    pkgs.gnugrep # Gitlab Runner somehow needs this before prebuild script (?)

    preBuildScript

    files.containers
    files.commonRoot
  ];

  extraCommands =
    # bash
    ''
      set -eu -o pipefail
      # All created directories belong to root.

      # Set missing Nix directories.
      mkdir -p -m 0755 nix/var/log/nix/drvs
      mkdir -p -m 0755 nix/var/nix/{gcroots,profiles,temproots,userpool}
      mkdir -p -m 1777 nix/var/nix/{gcroots,profiles}/per-user
      mkdir -p -m 0755 nix/var/nix/profiles/per-user/root


      # Need a temporary dir.
      mkdir -p -m 1777 tmp

      # Root User
      mkdir -p root
      mkdir -p \
          root/.config/nix \
          root/.local/state \
          root/.local/share \
          root/.cache

      # Need a home dir.
      mkdir -p -m 0755 home

      # Copy some files from the store to make them writable.
      # - The passwd/group/nsswitch files from the /nix/store
      #   as podman otherwise has troubles with changing stuff
      #   and overmounting.
      #   Podman Error: creating temporary passwd file for container ...
      #          container open /var/lib/containers/storage/overlay/.../merged/nix/#        store/h95gjpn0n006pp5s9dkpdin386jbpv4p-basic-root-files/etc/group:
      #          no such file or directory
      # - We need to allow modification of nix config for cachix as
      #   otherwise it is linked to the read only file in the store.
      filesToMakeWritable=(
        "etc/passwd" "etc/group" "etc/nsswitch.conf",
        "etc/nix/nix.conf"
      )
      for f in "''${filesToMakeWritable[@]}"; do
        if [ -L "$f" ]; then
          cp --no-preserve=all --remove-destination "$(readlink -f $f)" "$f"
        fi
      done
    '';

  fakeRootCommands =
    # bash
    ''
      # Create home.
      mkdir -p home/ci

      # Create XDG dirs.
      mkdir -p \
          home/ci/.config/nix \
          home/ci/.local/state \
          home/ci/.local/share \
          home/ci/.cache

      chown -R 1000:1000 home
    '';

  wrapWithStore =
    builder: attrs:
    let
      inner = builder attrs;
      innerFull = builder (attrs // { includeStorePaths = true; });
      res = inner.overrideAttrs (
        f: p: {
          # Some special attributes for separate inspection.
          passthru = {
            buildFull = innerFull;
            profileScript = initScripts.profile;
            entrypointScript = initScripts.entrypointScript;
          };
        }
      );
    in
    res;

  getFileInBase =
    imgConf: file:
    pkgs.writeShellScriptBin "get-file" ''
      ${lib.getExe pkgs.podman} run "${imgConf.imageName}@${imgConf.imageDigest}" \
      cat "${file}"
    '';

  envs = rec {
    common = {
      # Access to the nix daemon.
      NIX_REMOTE = "daemon";

      # Access to containerized podman.
      CONTAINER_HOST = "unix:///run/podman/podman.sock";

      PATH = "/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin";

      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

      # Make a fake nixpkgs which throws when using
      # `nix repl -f <nixpkgs>` for example.
      NIX_PATH = "nixpkgs=${files.fakeNixpkgs}";
    };

    nix = common // {
      IMAGE_OS_DIST = "nix";
    };

    ubuntu = common // {
      IMAGE_OS_DIST = "ubuntu";
    };
  };

  mkStubDrv =
    pkg:
    pkgs.writeShellApplication {
      name = "stub-${pkg.name}";
      runtimeInputs = [ pkg ];
      text = "echo 'Only a depend. stub for ${pkg}'";
    };

in
{
  inherit preBuildScript;

  # All these packages are added to the Nix daemon.
  # which will end up in a `nix-daemon-store` volume.
  # The derivations which are taken out from the images
  # must be added here.
  allStoreDrv = jobImagePkgs ++ [
    files.fakeNixpkgs
    (mkStubDrv files.nixImage)
    (mkStubDrv files.ubuntuImage)

    initScripts.profile
    initScripts.entrypoint
  ];

  images = {
    # The Nix image.
    nix = wrapWithStore pkgs.dockerTools.buildLayeredImage {
      name = imageNames.nix;
      tag = "latest";

      extraCommands = extraCommands + ''
        set -eu -o pipefail
        # For `/usr/bin/env`.
        mkdir -p usr && ln -s ../bin usr/bin
      '';

      inherit fakeRootCommands;

      contents = jobImagePkgs ++ [ files.nixImage ];
      # No store paths are copied into. We provide them by mounting the
      # /nix/store.
      includeStorePaths = false;

      config = {
        Labels = noPruneLabels;
        Env = toEnvList envs.nix;
        Entrypoint = [ "${lib.getExe initScripts.entrypoint}" ];
      };

      maxLayers = 2;
    };

    # This is the analog image to `local/nix` but ubuntu based.
    ubuntu =
      let
        # Update with:
        # ```shell
        # nix run "github:nixos/nixpkgs/nixos-unstable#nix-prefetch-docker" -- \
        #   --image-name ubuntu --image-tag latest
        # nix run ".#nixosConfigurations.gitlab-runner.config.virtualisation.oci-containers.containers.ubuntu-container.imageFile.originalPasswd" > files/ubuntu-image/etc/passwd
        # nix run ".#nixosConfigurations.gitlab-runner.config.virtualisation.oci-containers.containers.ubuntu-container.imageFile.originalGroup" > files/ubuntu-image/etc/group
        # ```
        imgConf = {
          imageName = "ubuntu";
          imageDigest = "sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02";
          hash = "sha256-aC8SgxdcMSaaU89YMr/uwE022Yqey2frmeZqr+L1xEU=";
          finalImageName = "ubuntu";
          finalImageTag = "latest";
        };
        ubuntuBase = pkgs.dockerTools.pullImage imgConf;
      in
      (wrapWithStore pkgs.dockerTools.buildLayeredImage {
        fromImage = ubuntuBase;
        name = imageNames.ubuntu;
        tag = "latest";

        inherit extraCommands;
        inherit fakeRootCommands;

        contents = jobImagePkgs ++ [ files.ubuntuImage ];
        # No store paths are copied into. We provide them by mounting the
        # /nix/store.
        includeStorePaths = false;

        config = {
          Labels = noPruneLabels;
          Env = toEnvList envs.ubuntu;
          Entrypoint = [ "${lib.getExe initScripts.entrypoint}" ];
        };

        # Only if `build buildLayeredImage`.
        maxLayers = 3;
      }).overrideAttrs
        (
          f: p: {
            passthru = p.passthru // {
              originalPasswd = getFileInBase imgConf "/etc/passwd";
              originalGroup = getFileInBase imgConf "/etc/group";
            };
          }
        );
  };
}
