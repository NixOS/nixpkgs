{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeDesktopItem,
  versionCheckHook,
  pkg-config,
  git,
  makeWrapper,
  copyDesktopItems,
  libx11,
  libGL,
  libxcb,
  libxkbcommon,
  dbus,
  udev,
  openssl,
  wayland,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buttplug-lite";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "runtime-shady-backroom";
    repo = "buttplug-lite";
    tag = finalAttrs.version;
    hash = "sha256-Z7xf+507rTWWygPV4p0+Q3e2rFIVgn1Ktu/W1P0FOfw=";
  };

  cargoHash = "sha256-XGfHJAlv1B+tFKhLqMWiUaVyCUnyuyVZmYz3wvwITQI=";

  desktopItems = [
    (makeDesktopItem {
      name = "buttplug-lite";
      exec = "buttplug-lite";
      desktopName = "Buttplug Lite";
      comment = "Simplified buttplug.io API for when JSON is infeasible";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    git
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    libx11
    libGL
    libxcb
    libxkbcommon
    dbus
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
    wayland
  ];

  postInstall = ''
    wrapProgram $out/bin/buttplug-lite --suffix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath (
        [
          libx11
          libGL
          libxcb
          libxkbcommon
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ wayland ]
      )
    }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Simplified buttplug.io API for when JSON is infeasible";
    homepage = "https://github.com/runtime-shady-backroom/buttplug-lite";
    changelog = "https://github.com/runtime-shady-backroom/buttplug-lite/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ toasteruwu ];
  };
})
