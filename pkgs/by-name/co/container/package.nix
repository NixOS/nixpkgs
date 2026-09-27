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
  plugins = {
    container-runtime-linux = "RuntimeLinux";
    container-network-vmnet = "NetworkVmnet";
    container-core-images = "CoreImages";
    machine-apiserver = "MachineAPIServer";
    k8s = "K8s";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "container";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "container";
    tag = finalAttrs.version;
    hash = "sha256-xL5dxCG6S4sOAvrk7E69cYKoGLXTYE13+yjBiZiisNI=";
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
    hash = "sha256-Fo5tU/+YVkSjMENnV33qoJzp5JUlbjFeWaungwzIEAw=";
  };

  # Sources/Plugins/MachineAPIServer/Resources/{init,create-user.sh}
  # are copied into Linux guests and must retain /bin/sh
  # macOS Nix store paths do not exist there
  dontPatchShebangs = true;

  RELEASE_VERSION = finalAttrs.version;

  # The release archive has no Git metadata
  GIT_COMMIT = "unknown";

  # SwiftPM's default installer does not provide upstream's plugin layout
  installPhase = ''
    runHook preInstall
    binPath="$(swiftpmBinPath)"
    install -Dm755 "$binPath/container" "$out/bin/container"
    install -Dm755 "$binPath/container-apiserver" "$out/bin/container-apiserver"
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: directory: ''
        pluginDir="$out/libexec/container/plugins/${name}"
        install -Dm755 "$binPath/${name}" "$pluginDir/bin/${name}"
        install -Dm644 Sources/Plugins/${directory}/config.toml "$pluginDir/config.toml"
        if [ -d Sources/Plugins/${directory}/Resources ]; then
          cp -R Sources/Plugins/${directory}/Resources "$pluginDir/resources"
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
