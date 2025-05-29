{
  lib,
  alsa-lib,
  buildGoModule,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
  nix-update-script,
  pkg-config,
  wrapGAppsHook4,
}:

buildGoModule rec {
  pname = "mpris-timer";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "efogdev";
    repo = "mpris-timer";
    tag = version;
    hash = "sha256-uFQJSKQ9k0fiOhzydJ7frs2kns9pSdZGILPGCW3QA1w=";
  };

  vendorHash = "sha256-vCzQiQsljNyI7nBYvq+C/dv0T186Lsj7rOq5xHMs3c0=";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    gobject-introspection
    gtk4
    libadwaita
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  tags = [
    "wayland"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/mpris-timer

    install -Dm644 internal/ui/res/icon.svg $out/share/icons/hicolor/scalable/apps/io.github.efogdev.mpris-timer.svg
    install -Dm644 misc/io.github.efogdev.mpris-timer.desktop -t $out/share/applications
    install -Dm644 misc/io.github.efogdev.mpris-timer.metainfo.xml -t $out/share/metainfo
    install -Dm644 misc/io.github.efogdev.mpris-timer.gschema.xml -t $out/share/glib-2.0/schemas
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Timer app with seamless GNOME integration";
    homepage = "https://github.com/efogdev/mpris-timer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      stunkymonkey
      getchoo
    ];
    mainProgram = "mpris-timer";
    # Always uses ALSA
    platforms = lib.platforms.linux;
  };
}
