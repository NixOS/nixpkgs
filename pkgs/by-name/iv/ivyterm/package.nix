{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  vte-gtk4,
}:

rustPlatform.buildRustPackage {
  pname = "ivyterm";
  version = "0-unstable-2024-10-23";

  src = fetchFromGitHub {
    owner = "Tomiyou";
    repo = "ivyterm";
    rev = "13ee76dfc88bc92807e328991c7a8586a5b13ac7";
    hash = "sha256-vxDJwA+ZM3ROX9d1+o3cXj4LbaO9Wy5jFAVuAPOzCCI=";
  };

  cargoHash = "sha256-tdaI0diwRjqERmAiuKFhMw4AeqxgMq8YMsZWBjsmd0U=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    vte-gtk4
  ];

  meta = {
    description = "Terminal emulator implemented in gtk4-rs and VTE4";
    homepage = "https://github.com/Tomiyou/ivyterm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "ivyterm";
  };
}
