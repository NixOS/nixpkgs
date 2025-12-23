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
  version = "25.2";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "oscavmgr";
    tag = "v${version}";
    hash = "sha256-592qj0dHn0fbIFt4Y+1TESIOUpwXcJ2tnlKNcYuxriQ=";
  };

  cargoHash = "sha256-1/jjZ1jkLvE/L1lHFL3RCx3ox2w15WWDp6aQJOtFkcU=";

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
