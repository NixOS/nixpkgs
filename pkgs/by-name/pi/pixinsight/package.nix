{
  lib,
  callPackage,
  buildFHSEnv,
  cudaPackages,
  config,
  cudaSupport ? config.cudaSupport,

  # Provide support for built-in self-updates and plugin management
  #
  # PixInsight installs updates and plugins in its main installation location,
  # which is incompatible with running it from immutable Nix store.
  #
  # `true`:
  # - configure mutable copy of PixInsight installation under
  #   `~/.local/share/pixinsight`, and run PixInsight using it
  # - whenever immutable installation changes, on launch clear and reinstall
  #   mutable files to keep synced with Nix store
  # - `PixInsightUpdater` is fully functional
  #
  # `false`:
  # - run PixInsight using immutable installation from Nix store
  # - `PixInsightUpdater` returns `Read-only file system` error on update
  #   installation attempt
  #
  # Enabled by default, as this is part of core functionality, expected from upstream
  enableUpdates ? true,
}:

let
  pixinsight = callPackage ./. { inherit cudaSupport; };

  # For CUDA support (PixInsight ships with `libtensorflow-cpu`)
  #
  # PixInsight uses C API `libtensorflow`, which differs from library shipped
  # with `tensorflow-bin`: in particular it contains `VERS_1.0` embedded.
  # Variants from `tensorflow-bin` don't embed it and are rejected as
  # incompatible, when PixInsight installs plugins to its internal runtime
  # environment and loads their dependencies.
  libtensorflow-gpu = callPackage ./libtensorflow-gpu.nix { };

  deployPath = "$HOME/.local/share/pixinsight";
  storePathFile = "${deployPath}/opt/PixInsight/.store-path";
in
buildFHSEnv {
  inherit (pixinsight) pname version;

  targetPkgs =
    pkgs:
    (with pkgs; [
      expat
      glib
      zlib
      udev
      dbus
      nspr
      nss
      openssl

      alsa-lib
      libxkbcommon

      libGL
      libdrm
      qt6Packages.qtbase
      gtk3
      fontconfig
      libjpeg8
      gd

      libssh2
      libpsl
      libidn2

      brotli
      libdeflate

      avahi-compat
      cups

      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxinerama
      libxrandr
      libxrender
      libxtst

      libsm
      libice

      libxcb
      libxkbfile
      libxcb-util
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
      # libxcb-cursor # Bundled by PixInsight
    ])
    ++ lib.optionals cudaSupport (
      [
        libtensorflow-gpu
      ]
      ++ (with pkgs.cudaPackages; [
        cudatoolkit
        cudnn
      ])
    );

  extraInstallCommands = ''
    # Provide second binary matching upstream CLI command (`PixInsight`)
    ln -s $out/bin/{pixinsight,PixInsight}

    # Provide desktop integration files
    ln -s {${pixinsight},$out}/share
  '';

  # Prepare mutable opt/ for self-update and plugin support
  # Clear and redeploy whenever `pixinsight` store path changes
  extraPreBwrapCmds = lib.optionalString enableUpdates ''
    set -e

    read -r DEPLOYED_PATH < "${storePathFile}" 2>/dev/null || DEPLOYED_PATH=""

    if [ "$DEPLOYED_PATH" != "${pixinsight}" ]; then
      echo "pixinsight: new PixInsight installation detected"
      echo "pixinsight: deploying ${pixinsight}/opt/PixInsight to ${deployPath}/opt/PixInsight..."

      mkdir -p "${deployPath}"/opt
      rm -rf "${deployPath}"/opt/PixInsight
      cp -R ${pixinsight}/opt/PixInsight "${deployPath}"/opt
      chmod -R u+w "${deployPath}"/opt/PixInsight

      echo "${pixinsight}" > "${storePathFile}"

      echo "pixinsight: deployed successfully"
    fi
  '';

  extraBwrapArgs =
    lib.optionals enableUpdates [
      # Bind-mount mutable opt/ to /opt
      ''--bind "${deployPath}"/opt /opt''
    ]
    ++ lib.optionals (!enableUpdates) [
      # Bind-mount immutable opt/ to /opt
      ''--ro-bind "${pixinsight}"/opt /opt''
    ];

  profile = lib.optionalString cudaSupport ''
    export XLA_FLAGS=--xla_gpu_cuda_data_dir=${cudaPackages.cudatoolkit}
  '';

  runScript = "/opt/PixInsight/bin/PixInsight.sh";

  passthru = {
    inherit libtensorflow-gpu;
    unwrapped = pixinsight;
  };

  inherit (pixinsight.meta)
    description
    homepage
    license
    maintainers
    platforms
    sourceProvenance
    hydraPlatforms
    ;
}
