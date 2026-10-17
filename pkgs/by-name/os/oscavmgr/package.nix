{
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  openvr,
  openxr-loader,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oscavmgr";
  version = "26.8.0";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "oscavmgr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BYS/1rsXlP67MlkStm45Dm8aZllaVVOmdq8Yf0jB0iM=";
  };

  cargoHash = "sha256-R8UzXy44fli54zHEIZ+MdpHEggvoD06YXm5gpfMNfK0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    openxr-loader
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postPatch = ''
    alvr_session=$(echo $cargoDepsCopy/*/alvr_session-*/)
    substituteInPlace "$alvr_session/build.rs" \
      --replace-fail \
        'alvr_filesystem::workspace_dir().join("openvr/headers/openvr_driver.h")' \
        '"${openvr}/include/openvr/openvr_driver.h"'

  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Face tracking & utilities for Resonite and VRChat";
    homepage = "https://github.com/galister/oscavmgr";
    changelog = "https://github.com/galister/oscavmgr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      Scrumplex
    ];
    mainProgram = "oscavmgr";
  };
})
