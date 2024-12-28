{
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  openvr,
  openxr-loader,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "oscavmgr";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "oscavmgr";
    rev = "refs/tags/v${version}";
    hash = "sha256-05dNBzf1f92bVNLbRaUB6KUae+wY3V8mUxDgAb+g1T4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fw26EbdCnz7KtDmCDpvfy4fjYORL2KcnhzQBJDdNEuI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    openxr-loader
  ];

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
