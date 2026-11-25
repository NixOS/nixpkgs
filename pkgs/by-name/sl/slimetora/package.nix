{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  nodejs_22,
  udev,

  electron,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,

  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "slimetora";
  version = "1.5.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCSYT";
    repo = "SlimeTora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x95UvFIDFDT9cMhIRSONnIBktEpzIZazCDENs9ESG00=";
  };

  npmDepsHash = "sha256-Ob2LvAbp0lxmLC9HSRPvwi1TSgJUGmrvXlMFU0pXCLM=";
  nodejs = nodejs_22;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    udev
  ];

  patches = [
    # write config and logs to XDG_DATA_HOME
    ./change-data-dir.patch

    # the default server address doesn't work on Linux
    ./server-addr.patch
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  npmBuildScript = "preload";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "npx " "npx --offline "
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "SlimeTora";
      exec = "${finalAttrs.pname} %U";
      icon = finalAttrs.pname;
      categories = [ "Utility" ];
      keywords = [
        "HaritoraX"
        "SlimeVR"
        "FBT"
      ];
      comment = finalAttrs.meta.description;
      startupWMClass = "slimetora";
    })
  ];

  postInstall = ''
    install -Dm444 $src/docs/icon.png $out/share/icons/hicolor/512x512/apps/${finalAttrs.pname}.png

    makeWrapper ${electron}/bin/electron $out/bin/${finalAttrs.pname} \
      --run "mkdir -p '$${XDG_DATA_HOME-$HOME/.local/share}/slimetora'" \
      --add-flags $out/lib/node_modules/${finalAttrs.pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    copyDesktopItems
  '';

  makeCacheWritable = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Connect the HaritoraX trackers to the SlimeVR server";
    longDescription = ''
      A program that connects the HaritoraX trackers to the [SlimeVR server](https://docs.slimevr.dev/server/index.html),
      supporting the `HaritoraX 2`, `HaritoraX Wireless` and`HaritoraX Wired` (1.1b/1.1/1.0).
      Supports `Bluetooth` (low energy), `Bluetooth` (classic) (w/ `COM`), and the `GX(6/2)` communication dongles (w/ `COM`).
    '';
    homepage = "https://github.com/OCSYT/SlimeTora";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hpenney2
    ];
    platforms = lib.platforms.linux;
    mainProgram = "slimetora";
  };
})
