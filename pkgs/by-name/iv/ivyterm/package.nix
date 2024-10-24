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
  version = "unstable-2024-10-23";

  src = fetchFromGitHub {
    owner = "Tomiyou";
    repo = "ivyterm";
    rev = "24318ec9a9a93fc5e0d688bde03f6d109733abe8";
    hash = "sha256-vxDJwA+ZM3ROX9d1+o3cXj4LbaO9Wy5jFAVuAPOzCCI=";
  };

  cargoHash = "sha256-WttmZi+TJ1z3TMgSsHae58wG2QKV/LVXyLSp3/6fTqQ=";

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
