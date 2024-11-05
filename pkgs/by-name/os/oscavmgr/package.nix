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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "oscavmgr";
    rev = "refs/tags/v${version}";
    hash = "sha256-mOa9eUI/p0ErePza6wXy1jUcHg5Q9tvC7/lThQabU94=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alvr_common-20.11.1" = "sha256-d4KldPii8W1HcfnMSD8Fn+IGO/a3r8747APPjRCnbe8=";
      "openxr-0.19.0" = "sha256-kbEYoN4UvUEaZA9LJWEKx1X1r+l91GjTWs1hNXhr7cw=";
      "settings-schema-0.2.0" = "sha256-luEdAKDTq76dMeo5kA+QDTHpRMFUg3n0qvyQ7DkId0k=";
    };
  };

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
