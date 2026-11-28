{
  lib,
  stdenv,
  fetchFromGitHub,
  swift,
  swiftpm,
  fetchSwiftPMDeps,
  apple-sdk_26,
  darwinMinVersionHook,
  libarchive,
  zlib,
  bzip2,
  xz,
  libiconv,
  installShellFiles,
  makeBinaryWrapper,
  rcodesign,
  versionCheckHook,
  nix-update-script,
}:

let
  # Plugin directory name -> SwiftPM executable and source directory under Sources/Plugins,
  # matching the layout of upstream's `make install`
  plugins = {
    container-runtime-linux = {
      executable = "container-runtime-linux";
      source = "RuntimeLinux";
    };
    container-network-vmnet = {
      executable = "container-network-vmnet";
      source = "NetworkVmnet";
    };
    container-core-images = {
      executable = "container-core-images";
      source = "CoreImages";
    };
    machine-apiserver = {
      executable = "machine-apiserver";
      source = "MachineAPIServer";
    };
    cluster = {
      executable = "cluster";
      source = "Cluster";
    };
    build = {
      executable = "container-build";
      source = "ContainerBuild";
    };
    builder = {
      executable = "container-builder";
      source = "ContainerBuilder";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "container";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "container";
    tag = finalAttrs.version;
    hash = "sha256-2CKREVTZvXIrGtmgj84Wnrg6ML4Bm5aAF0SPuAqEh9I=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
    installShellFiles
    makeBinaryWrapper
    rcodesign
  ];

  buildInputs = [
    apple-sdk_26
    (darwinMinVersionHook "15.0")
    libarchive
    zlib
    bzip2
    xz
    libiconv
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-g2ZdIqfcNGFpRS9aN6zoB3dmm1SKzApYWwsFtrJDT8M=";
  };

  # Sources/Plugins/MachineAPIServer/Resources/{init,create-user.sh}
  # are copied into Linux guests and must retain /bin/sh
  # macOS Nix store paths do not exist there
  dontPatchShebangs = true;

  env = {
    RELEASE_VERSION = finalAttrs.version;

    # The release archive has no Git metadata
    GIT_COMMIT = "unknown";
  };

  # SwiftPM's default installer does not provide upstream's plugin layout
  installPhase = ''
    runHook preInstall
    binPath="$(swiftpmBinPath)"
    install -Dm755 "$binPath/container" "$out/bin/container"
    install -Dm755 "$binPath/container-apiserver" "$out/bin/container-apiserver"
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: plugin: ''
        pluginDir="$out/libexec/container/plugins/${name}"
        install -Dm755 "$binPath/${plugin.executable}" "$pluginDir/bin/${name}"
        install -Dm644 Sources/Plugins/${plugin.source}/config.toml "$pluginDir/config.toml"
        if [ -d Sources/Plugins/${plugin.source}/Resources ]; then
          cp -R Sources/Plugins/${plugin.source}/Resources "$pluginDir/resources"
        fi
      '') plugins
    )}
    runHook postInstall
  '';

  postFixup = ''
    for name in container-runtime-linux container-network-vmnet; do
      rcodesign sign --entitlements-xml-file "signing/$name.entitlements" \
        "$out/libexec/container/plugins/$name/bin/$name"
    done
    wrapProgram "$out/bin/container" --set-default CONTAINER_INSTALL_ROOT "$out"
    wrapProgram "$out/bin/container-apiserver" --set-default CONTAINER_INSTALL_ROOT "$out"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      "$out/bin/container" --generate-completion-script "$shell" > "container.$shell"
    done
    installShellCompletion --cmd container \
      --bash container.bash \
      --fish container.fish \
      --zsh container.zsh
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru = {
    # nix-update does not detect SwiftPM dependencies automatically
    swiftpmVendor = finalAttrs.swiftpmDeps.vendorStaging;
    updateScript = nix-update-script {
      extraArgs = [
        "--custom-dep"
        "swiftpmVendor"
      ];
    };
  };

  meta = {
    description = "Create and run Linux containers using lightweight virtual machines on a Mac";
    homepage = "https://github.com/apple/container";
    changelog = "https://github.com/apple/container/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "container";
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      Br1ght0ne
    ];
    platforms = [ "aarch64-darwin" ];
  };
})
