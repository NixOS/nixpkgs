{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  replaceVars,
  fetchpatch2,
  nodejs,
  pnpmConfigHook,
  pnpm_9,
  electron,
  makeWrapper,
  slimevr-server,
  copyDesktopItems,
  makeDesktopItem,
  udevCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "slimevr";
  version = "19.0.0";

  src = fetchFromGitHub {
    owner = "SlimeVR";
    repo = "SlimeVR-Server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8kduLKJkGsTYZidlo0NwpE3d3S6o3RoaHznes8YuF1Y=";
    # solarxr
    fetchSubmodules = true;
  };

  pnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-pnpm-deps";
    inherit (finalAttrs) version src;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-Lonwn3YPBRQrD/L2ob0GDOjX6p8fXf5VD8cBpbAb5bw=";
  };

  patches = [
    # Upstream code uses Git to find the program version.
    (replaceVars ./gui-no-git.patch {
      version = finalAttrs.src.tag;
    })
    # By default, SlimeVR will give a big warning about our `JAVA_TOOL_OPTIONS` changes.
    ./no-java-tool-options-warning.patch
    # For Wayland Electron arugments.
    (fetchpatch2 {
      name = "allow-passing-excess-cli-arguments-to-electron.patch";
      url = "https://github.com/SlimeVR/SlimeVR-Server/commit/be77ff73d71238a586e27fbad768e18a31877b74.patch?full_index=1";
      hash = "sha256-xK8/PrjWEREFa3s0xOoiDpR5tsolFY+4psiHk8KfcTM=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
    makeWrapper
    copyDesktopItems
    udevCheckHook
  ];

  # solarxr needs to be installed after compiling its Typescript files. This isn't
  # done the first time, because `pnpmConfigHook` ignores `package.json` scripts.
  preBuild = ''
    pnpm --filter solarxr-protocol build
  '';

  doCheck = false; # No tests
  doInstallCheck = true; # Check udev

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    pushd gui
    pnpm build
    pnpm exec electron-builder \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/slimevr
    cp -r gui/dist/artifacts/*/*-unpacked/{locales,resources{,.pak}} $out/share/slimevr/
    # `JAVA_HOME`, `JAVA_TOOL_OPTIONS`, and `--path` are so the GUI can
    # launch the server.
    makeWrapper ${lib.getExe electron} $out/bin/slimevr \
      --add-flags $out/share/slimevr/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set JAVA_HOME "${slimevr-server.passthru.java.home}" \
      --set JAVA_TOOL_OPTIONS "${slimevr-server.passthru.javaOptions}" \
      --add-flags "--path ${slimevr-server}/share/slimevr" \
      --inherit-argv0

    install -Dm444 gui/electron/resources/icons/icon.png $out/share/icons/hicolor/512x512/apps/slimevr.png
    install -Dm644 -t $out/lib/udev/rules.d/ gui/electron/resources/69-slimevr-devices.rules

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "slimevr";
      desktopName = "SlimeVR";
      genericName = "Full-body tracking";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
      keywords = [
        "FBT"
        "VR"
        "Steam"
        "VRChat"
        "IMU"
      ];
      icon = "slimevr";
      exec = "slimevr";
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://slimevr.dev";
    changelog = "https://github.com/SlimeVR/SlimeVR-Server/releases/tag/v${finalAttrs.version}";
    description = "App for facilitating full-body tracking in virtual reality";
    longDescription = ''
      App for SlimeVR ecosystem. It orchestrates communication between multiple sensors and integrations, like SteamVR.

      Sensors implementations:

      - [SlimeVR Tracker for ESP](https://github.com/SlimeVR/SlimeVR-Tracker-ESP) - ESP microcontrollers and multiple IMUs are supported
      - [owoTrack Mobile App](https://github.com/abb128/owoTrackVRSyncMobile) - use phones as trackers (limited functionality and compatibility)
      - [SlimeVR Wrangler](https://github.com/carl-anders/slimevr-wrangler) - use Nintendo Switch Joycon controllers as trackers

      Integrations:

      - Use [SlimeVR OpenVR Driver](https://github.com/SlimeVR/SlimeVR-OpenVR-Driver) as a driver for SteamVR.
      - Use built-in OSC Trackers support for FBT integration with VRChat, PCVR or Standalone.
      - Use built-in VMC support for sending and receiving tracking data to and from other apps such as VSeeFace.
      - Export recordings as .BVH files to integrate motion capture data into 3d applications such as Blender.

      More at https://docs.slimevr.dev/tools/index.html.
    '';
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      gale-username
      loucass003
    ];
    platforms = with lib.platforms; darwin ++ linux;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "slimevr";
  };
})
