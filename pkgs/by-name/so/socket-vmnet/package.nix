{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "socket-vmnet";
  version = "1.2.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "socket_vmnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D5Z4aml82h397ho48HFeXwR6y2XkopFIKjO09jUgFdo=";
  };

  postPatch = ''
    # NOTA BENE:
    # Since socket_vmnet is macOS only the upstream Makefile assumes
    # standard system utilities such as date from /bin/ and logger
    # from /usr/bin are available through $PATH.
    # This is not the case for the nixpkgs build environment.
    # To maintain compatability with nixpkgs build env nixpkgs dependency
    # purity and the following replacements are made:
    substituteInPlace Makefile \
       --replace-fail "logger" "echo" \
       --replace-fail "-r $(SOURCE_DATE_EPOCH)" "-d @$(SOURCE_DATE_EPOCH)"
    substituteInPlace launchd/io.github.lima-vm.socket_vmnet{,.bridged.en0}.plist \
      --replace-fail "/opt/socket_vmnet/bin/socket_vmnet" "${placeholder "out"}/bin/socket_vmnet"
  '';

  dontConfigure = true;

  makeFlags = [
    "VERSION=${finalAttrs.version}"
    "SOURCE_DATE_EPOCH=0"
  ];

  makeTargets = [
    "socket_vmnet"
    "socket_vmnet_client"
  ];

  installPhase = ''
    runHook preInstall

    make PREFIX=$out $makeFlags install.{bin,doc}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vmnet.framework support for unmodified rootless QEMU";
    homepage = "https://github.com/lima-vm/socket_vmnet";
    changelog = "https://github.com/lima-vm/socket_vmnet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ afh ];
    mainProgram = "socket_vmnet";
    platforms = lib.platforms.darwin;
  };
})
