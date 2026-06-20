{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  accountsservice,
  dbus,
  glib,
  gst_all_1,
  gtk4,
  pango,
  librsvg,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "regreet";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = finalAttrs.version;
    hash = "sha256-WLngdmv5qrHaJ5P2mN/KO3YijwWOs1wKSliaAf3okvs=";
  };

  cargoHash = "sha256-Jt8vGJzCYtpIPWxHHIc4x8zwjTF9tiM4YbBy9o9pxX4=";

  buildFeatures = [ "gtk4_8" ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    accountsservice
    dbus
    glib
    gtk4
    gst_all_1.gstreamer # Used for animated wallpapers or video playback
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
    pango
    librsvg
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clean and customizable greeter for greetd";
    homepage = "https://github.com/rharish101/ReGreet";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
    mainProgram = "regreet";
  };
})
