{
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildPackages,
  cmake,
  copyDesktopItems,
  leptonica,
  libxkbcommon,
  makeDesktopItem,
  nix-update-script,
  openssl,
  pipewire,
  pkg-config,
  tesseract,
  versionCheckHook,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "auv";
  version = "0.0.34";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "moeru-ai";
    repo = "auv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4C9fGlT0asW/ZttW6Q9PHS89KwHTFfV8GsJfTjfriaU=";
  };

  cargoHash = "sha256-bRzlOfR9pASHWHYdcqpRx+S/5Mq0uku7nfTxCuzoUJ8=";

  nativeBuildInputs = [
    buildPackages.protobuf
    cmake
    copyDesktopItems
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    leptonica
    libxkbcommon
    openssl
    pipewire
    tesseract
    wayland
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    PROTOC = lib.getExe buildPackages.protobuf;
  };

  cargoBuildFlags = [ "-p=auv-cli" ];

  # Device-local daemon tests require a root-owned, sticky /tmp, whose owner UID
  # may be unmapped in Linux build sandboxes.
  cargoTestFlags = finalAttrs.cargoBuildFlags ++ [
    "--lib"
    "--test=op_cli"
  ];

  checkFlags = [
    # These unit tests also depend on the /tmp ownership check.
    "--skip=commands::device_local::tests::replacing_control_directory_cannot_redirect_local_socket"
    "--skip=commands::device_local::tests::socket_is_resolved_only_from_the_local_store"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.moeru.auv";
      desktopName = "AUV";
      comment = finalAttrs.meta.description;
      exec = finalAttrs.meta.mainProgram;
      noDisplay = true;
      terminal = false;
    })
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OS automation toolkit, a programmable computer use";
    homepage = "https://github.com/moeru-ai/auv";
    changelog = "https://github.com/moeru-ai/auv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "auv";
    maintainers = with lib.maintainers; [ kwaa ];
    platforms = lib.platforms.linux;
  };
})
