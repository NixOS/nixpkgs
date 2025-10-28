{
  lib,
  fetchFromGitHub,
  stdenv,
  replaceVars,
  makeWrapper,
  slimevr-server,
  nodejs,
  pnpm_9,
  rustPlatform,
  cargo-tauri,
  wrapGAppsHook3,
  pkg-config,
  openssl,
  glib-networking,
  webkitgtk_4_1,
  gst_all_1,
  libayatana-appindicator,
  udevCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "slimevr";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "SlimeVR";
    repo = "SlimeVR-Server";
    tag = "v${version}";
    hash = "sha256-RYHt0njzzom1wrHTP/7ch/D+YZcixqOeLMcfsGi+Kg8=";
    # solarxr
    fetchSubmodules = true;
  };

  buildAndTestSubdir = "gui/src-tauri";

  cargoHash = "sha256-w2z+EQqkVGLmXQS+AzeJwkGG4ovpz9+ovmLOcUks734=";

  pnpmDeps = pnpm_9.fetchDeps {
    pname = "${pname}-pnpm-deps";
    inherit version src;
    fetcherVersion = 1;
    hash = "sha256-b0oCOjxrUQqWmUR6IzTEO75pvJZB7MQD14DNbQm95sA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
    makeWrapper
    udevCheckHook
  ];

  buildInputs = [
    openssl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libayatana-appindicator
    webkitgtk_4_1
  ];

  patches = [
    # Upstream code uses Git to find the program version.
    (replaceVars ./gui-no-git.patch {
      version = src.rev;
    })
    # By default, SlimeVR will give a big warning about our `JAVA_TOOL_OPTIONS` changes.
    ./no-java-tool-options-warning.patch
  ];

  postPatch = ''
    # Tauri bundler expects slimevr.jar to exist.
    mkdir -p server/desktop/build/libs
    touch server/desktop/build/libs/slimevr.jar
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Both libappindicator-rs and SlimeVR need to know where Nix's appindicator lib is.
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    substituteInPlace gui/src-tauri/src/tray.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  # solarxr needs to be installed after compiling its Typescript files. This isn't
  # done the first time, because `pnpm_9.configHook` ignores `package.json` scripts.
  preBuild = ''
    pnpm --filter solarxr-protocol build
  '';

  doCheck = false; # No tests
  doInstallCheck = true; # Check udev

  # Get rid of placeholder slimevr.jar
  postInstall = ''
    rm $out/share/slimevr/slimevr.jar
    rm -d $out/share/slimevr

    install -Dm644 -t $out/lib/udev/rules.d/ gui/src-tauri/69-slimevr-devices.rules
  '';

  # `JAVA_HOME`, `JAVA_TOOL_OPTIONS`, and `--launch-from-path` are so the GUI can
  # launch the server.
  postFixup = ''
    wrapProgram "$out/bin/slimevr" \
      --set JAVA_HOME "${slimevr-server.passthru.java.home}" \
      --set JAVA_TOOL_OPTIONS "${slimevr-server.passthru.javaOptions}" \
      --add-flags "--launch-from-path ${slimevr-server}/share/slimevr"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://slimevr.dev";
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
      imurx
    ];
    platforms = with lib.platforms; darwin ++ linux;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "slimevr";
  };
}
