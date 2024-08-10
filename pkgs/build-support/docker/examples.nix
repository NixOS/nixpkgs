# Examples of using the docker tools to build packages.
#
# This file defines several docker images. In order to use an image,
# build its derivation with `nix-build`, and then load the result with
# `docker load`. For example:
#
#  $ nix-build '<nixpkgs>' -A dockerTools.examples.redis
#  $ docker load < result

{ pkgs, buildImage, buildLayeredImage, fakeNss, pullImage, shadowSetup, buildImageWithNixDb, pkgsCross, streamNixShellImage }:

let
  nixosLib = import ../../../nixos/lib {
    # Experimental features need testing too, but there's no point in warning
    # about it, so we enable the feature flag.
    featureFlags.minimalModules = {};
  };
  evalMinimalConfig = module: nixosLib.evalModules { modules = [ module ]; };

in

rec {
  # 1. basic example
  bash = buildImage {
    name = "bash";
    tag = "latest";
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths = [ pkgs.bashInteractive ];
      pathsToLink = [ "/bin" ];
    };
  };

  # 2. service example, layered on another image
  redis = buildImage {
    name = "redis";
    tag = "latest";

    # for example's sake, we can layer redis on top of bash or debian
    fromImage = bash;
    # fromImage = debian;

    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths = [ pkgs.redis ];
      pathsToLink = [ "/bin" ];
    };

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
      mkdir -p tmp/nginx_client_body

      # nginx still tries to read this directory even if error_log
      # directive is specifying another file :/
      mkdir -p var/log/nginx
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
  testNixFromDockerHub = pkgs.testers.invalidateFetcherByDrvHash pullImage {
    imageName = "nixos/nix";
    imageDigest = "sha256:85299d86263a3059cf19f419f9d286cc9f06d3c13146a8ebbb21b3437f598357";
    sha256 = "19fw0n3wmddahzr20mhdqv6jkjn1kanh6n2mrr08ai53dr8ph5n7";
    finalImageTag = "2.2.1";
    finalImageName = "nix";
  };

  # 5. example of multiple contents, emacs and vi happily coexisting
  editors = buildImage {
    name = "editors";
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [
        pkgs.coreutils
        pkgs.bash
        pkgs.emacs
        pkgs.vim
        pkgs.nano
      ];
    };
  };

  # 6. nix example to play with the container nix store
  # docker run -it --rm nix nix-store -qR $(nix-build '<nixpkgs>' -A nix)
  nix = buildImageWithNixDb {
    name = "nix";
    tag = "latest";
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [
        # nix-store uses cat program to display results as specified by
        # the image env variable NIX_PAGER.
        pkgs.coreutils
        pkgs.nix
        pkgs.bash
      ];
    };
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
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ pkgs.hello ];
    };
  };

  # 8. regression test for erroneous use of eval and string expansion.
  # See issue #34779 and PR #40947 for details.
  runAsRootExtraCommands = pkgs.dockerTools.buildImage {
    name = "runAsRootExtraCommands";
    tag = "latest";
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ pkgs.coreutils ];
    };
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
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ pkgs.coreutils ];
    };
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
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ pkgs.coreutils ];
    };
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
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ pkgs.coreutils ];
    };
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

      # This is a "build" dependency that will not appear in the image
      ${pkgs.hello}/bin/hello
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

  # 23. Ensure that layers are unpacked in the correct order before the
  # runAsRoot script is executed.
  layersUnpackOrder =
  let
    layerOnTopOf = parent: layerName:
      pkgs.dockerTools.buildImage {
        name = "layers-unpack-order-${layerName}";
        tag = "latest";
        fromImage = parent;
        copyToRoot = pkgs.buildEnv {
          name = "image-root";
          pathsToLink = [ "/bin" ];
          paths = [ pkgs.coreutils ];
        };
        runAsRoot = ''
          #!${pkgs.runtimeShell}
          echo -n "${layerName}" >> /layer-order
        '';
      };
    # When executing the runAsRoot script when building layer C, if layer B is
    # not unpacked on top of layer A, the contents of /layer-order will not be
    # "ABC".
    layerA = layerOnTopOf null   "a";
    layerB = layerOnTopOf layerA "b";
    layerC = layerOnTopOf layerB "c";
  in layerC;

  bashUncompressed = pkgs.dockerTools.buildImage {
    name = "bash-uncompressed";
    tag = "latest";
    compressor = "none";
    # Not recommended. Use `buildEnv` between copy and packages to avoid file duplication.
    copyToRoot = pkgs.bashInteractive;
  };

  bashZstdCompressed = pkgs.dockerTools.buildImage {
    name = "bash-zstd";
    tag = "latest";
    compressor = "zstd";
    # Not recommended. Use `buildEnv` between copy and packages to avoid file duplication.
    copyToRoot = pkgs.bashInteractive;
  };

  # buildImage without explicit tag
  bashNoTag = pkgs.dockerTools.buildImage {
    name = "bash-no-tag";
    # Not recommended. Use `buildEnv` between copy and packages to avoid file duplication.
    copyToRoot = pkgs.bashInteractive;
  };

  # buildLayeredImage without explicit tag
  bashNoTagLayered = pkgs.dockerTools.buildLayeredImage {
    name = "bash-no-tag-layered";
    contents = pkgs.bashInteractive;
  };

  # buildLayeredImage without compression
  bashLayeredUncompressed = pkgs.dockerTools.buildLayeredImage {
    name = "bash-layered-uncompressed";
    tag = "latest";
    compressor = "none";
    contents = pkgs.bashInteractive;
  };

  # buildLayeredImage with zstd compression
  bashLayeredZstdCompressed = pkgs.dockerTools.buildLayeredImage {
    name = "bash-layered-zstd";
    tag = "latest";
    compressor = "zstd";
    contents = pkgs.bashInteractive;
  };

  # streamLayeredImage without explicit tag
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
      if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then pkgsCross.gnu64
      else pkgsCross.aarch64-multiplatform;
  in crossPkgs.dockerTools.buildImage {
    name = "hello-cross";
    tag = "latest";
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [ crossPkgs.hello ];
    };
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
      mkdir -p ./home/alice
      chown 1000 ./home/alice
      ln -s ${pkgs.hello.overrideAttrs (finalAttrs: prevAttrs: {
        # A unique `hello` to make sure that it isn't included via another mechanism by accident.
        configureFlags = prevAttrs.configureFlags or [] ++ [ " --program-prefix=layeredImageWithFakeRootCommands-" ];
        doCheck = false;
        versionCheckProgram = "${builtins.placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
        meta = prevAttrs.meta // {
          mainProgram = "layeredImageWithFakeRootCommands-hello";
        };
      })} ./hello
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
  # /home/alice directory
  mergedBashFakeRoot = pkgs.dockerTools.mergeImages [
    bash
    layeredImageWithFakeRootCommands
  ];

  mergeVaryingCompressor = pkgs.dockerTools.mergeImages [
    redis
    bashUncompressed
    bashZstdCompressed
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

  helloOnRootNoStoreFakechroot = pkgs.dockerTools.streamLayeredImage {
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
    enableFakechroot = true;
  };

  etc =
    let
      inherit (pkgs) lib;
      nixosCore = (evalMinimalConfig ({ config, ... }: {
        imports = [
          pkgs.pkgsModule
          ../../../nixos/modules/system/etc/etc.nix
        ];
        environment.etc."some-config-file" = {
          text = ''
            127.0.0.1 localhost
            ::1 localhost
          '';
          # For executables:
          # mode = "0755";
        };
      }));
    in pkgs.dockerTools.streamLayeredImage {
      name = "etc";
      tag = "latest";
      enableFakechroot = true;
      fakeRootCommands = ''
        mkdir -p /etc
        ${nixosCore.config.system.build.etcActivationCommands}
      '';
      config.Cmd = pkgs.writeScript "etc-cmd" ''
        #!${pkgs.busybox}/bin/sh
        ${pkgs.busybox}/bin/cat /etc/some-config-file
      '';
    };

  # Example export of the bash image
  exportBash = pkgs.dockerTools.exportImage { fromImage = bash; };

  imageViaFakeChroot = pkgs.dockerTools.streamLayeredImage {
    name = "image-via-fake-chroot";
    tag = "latest";
    config.Cmd = [ "hello" ];
    enableFakechroot = true;
    # Crucially, instead of a relative path, this creates /bin, which is
    # intercepted by fakechroot.
    # This functionality is not available on darwin as of 2021.
    fakeRootCommands = ''
      mkdir /bin
      ln -s ${pkgs.hello}/bin/hello /bin/hello
    '';
  };

  build-image-with-path = buildImage {
    name = "build-image-with-path";
    tag = "latest";
    # Not recommended. Use `buildEnv` between copy and packages to avoid file duplication.
    copyToRoot = [ pkgs.bashInteractive ./test-dummy ];
  };

  layered-image-with-path = pkgs.dockerTools.streamLayeredImage {
    name = "layered-image-with-path";
    tag = "latest";
    contents = [ pkgs.bashInteractive ./test-dummy ];
  };

  build-image-with-architecture = buildImage {
    name = "build-image-with-architecture";
    tag = "latest";
    architecture = "arm64";
    # Not recommended. Use `buildEnv` between copy and packages to avoid file duplication.
    copyToRoot = [ pkgs.bashInteractive ./test-dummy ];
  };

  layered-image-with-architecture = pkgs.dockerTools.streamLayeredImage {
    name = "layered-image-with-architecture";
    tag = "latest";
    architecture = "arm64";
    contents = [ pkgs.bashInteractive ./test-dummy ];
  };

  # ensure that caCertificates builds
  image-with-certs = buildImage {
    name = "image-with-certs";
    tag = "latest";

    copyToRoot = pkgs.buildEnv {
      name = "image-with-certs-root";
      paths = [
        pkgs.coreutils
        pkgs.dockerTools.caCertificates
      ];
    };

    config = {
    };
  };

  nix-shell-basic = streamNixShellImage {
    name = "nix-shell-basic";
    tag = "latest";
    drv = pkgs.hello;
  };

  nix-shell-hook = streamNixShellImage {
    name = "nix-shell-hook";
    tag = "latest";
    drv = pkgs.mkShell {
      shellHook = ''
        echo "This is the shell hook!"
        exit
      '';
    };
  };

  nix-shell-inputs = streamNixShellImage {
    name = "nix-shell-inputs";
    tag = "latest";
    drv = pkgs.mkShell {
      nativeBuildInputs = [
        pkgs.hello
      ];
    };
    command = ''
      hello
    '';
  };

  nix-shell-pass-as-file = streamNixShellImage {
    name = "nix-shell-pass-as-file";
    tag = "latest";
    drv = pkgs.mkShell {
      str = "this is a string";
      passAsFile = [ "str" ];
    };
    command = ''
      cat "$strPath"
    '';
  };

  nix-shell-run = streamNixShellImage {
    name = "nix-shell-run";
    tag = "latest";
    drv = pkgs.mkShell {};
    run = ''
      case "$-" in
      *i*) echo This shell is interactive ;;
      *) echo This shell is not interactive ;;
      esac
    '';
  };

  nix-shell-command = streamNixShellImage {
    name = "nix-shell-command";
    tag = "latest";
    drv = pkgs.mkShell {};
    command = ''
      case "$-" in
      *i*) echo This shell is interactive ;;
      *) echo This shell is not interactive ;;
      esac
    '';
  };

  nix-shell-writable-home = streamNixShellImage {
    name = "nix-shell-writable-home";
    tag = "latest";
    drv = pkgs.mkShell {};
    run = ''
      if [[ "$HOME" != "$(eval "echo ~$(whoami)")" ]]; then
        echo "\$HOME ($HOME) is not the same as ~\$(whoami) ($(eval "echo ~$(whoami)"))"
        exit 1
      fi

      if ! touch $HOME/test-file; then
        echo "home directory is not writable"
        exit 1
      fi
      echo "home directory is writable"
    '';
  };

  nix-shell-nonexistent-home = streamNixShellImage {
    name = "nix-shell-nonexistent-home";
    tag = "latest";
    drv = pkgs.mkShell {};
    homeDirectory = "/homeless-shelter";
    run = ''
      if [[ "$HOME" != "$(eval "echo ~$(whoami)")" ]]; then
        echo "\$HOME ($HOME) is not the same as ~\$(whoami) ($(eval "echo ~$(whoami)"))"
        exit 1
      fi

      if -e $HOME; then
        echo "home directory exists"
        exit 1
      fi
      echo "home directory doesn't exist"
    '';
  };

  nix-shell-build-derivation = streamNixShellImage {
    name = "nix-shell-build-derivation";
    tag = "latest";
    drv = pkgs.hello;
    run = ''
      buildDerivation
      $out/bin/hello
    '';
  };

  nix-layered = pkgs.dockerTools.streamLayeredImage  {
    name = "nix-layered";
    tag = "latest";
    contents = [ pkgs.nix pkgs.bash ];
    includeNixDB = true;
    config = {
      Env = [
        "NIX_PAGER=cat"
      ];
    };
  };

}
