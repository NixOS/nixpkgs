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

rustPlatform.buildRustPackage rec {
  pname = "oscavmgr";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "oscavmgr";
    tag = "v${version}";
    hash = "sha256-Tx4FuKKorQLkuhBUbQXtfsm8sFdLgQCgXiGQsfX+MQg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-91gYGDZyk6qyAF+WVxlQV18kCf3ADgRB2tw9OatvGbY=";

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
    alvr_session=$(echo $cargoDepsCopy/alvr_session-*/)
    substituteInPlace "$alvr_session/build.rs" \
      --replace-fail \
        'alvr_filesystem::workspace_dir().join("openvr/headers/openvr_driver.h")' \
        '"${openvr}/include/openvr/openvr_driver.h"'

  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Face tracking & utilities for Resonite and VRChat";
    homepage = "https://github.com/galister/oscavmgr";
    changelog = "https://github.com/galister/oscavmgr/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      Scrumplex
    ];
    mainProgram = "oscavmgr";
  };
}
