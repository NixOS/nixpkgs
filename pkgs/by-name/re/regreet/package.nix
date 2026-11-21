{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  accountsservice,
  dbus,
  glib,
  gstreamer,
  gst-plugins-good,
  gst-plugins-base,
  gtk4,
  pango,
  librsvg,
  libseccomp,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "regreet";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = finalAttrs.version;
    hash = "sha256-fJZqEcsqorTJA5qFhJ8wcNZKAC3q/KKFFIEZlrnkGHQ=";
  };

  cargoHash = "sha256-vWZ5lF5VKAPJTamvU/EavMHZsp4Gu2JvH4kbAvOqWTY=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    accountsservice
    dbus
    glib
    gtk4
    gstreamer # Used for animated wallpapers or video playback
    gst-plugins-good
    gst-plugins-base
    pango
    librsvg
    libseccomp
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
