{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  glib,
  wrapGAppsHook4,
  alsa-lib,
  gobject-introspection,
  gtk4,
  libadwaita,
}:

buildGoModule rec {
  pname = "mpris-timer";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "efogdev";
    repo = "mpris-timer";
    rev = "refs/tags/${version}";
    hash = "sha256-Ak9DASAfW+dOhfbQDRAZJ1YD8j5Fcpz05jlXlUG1ydo=";
  };
  vendorHash = "sha256-APcQgNEn7ULIjBk7f4q6MMSX9k58+F7vzgUDiIZ3Jxc=";

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
    install -Dm644 internal/ui/res/icon.svg $out/share/icons/hicolor/scalable/apps/io.github.efogdev.mpris-timer.svg
    install -Dm644 misc/io.github.efogdev.mpris-timer.desktop -t $out/share/applications
    install -Dm644 misc/io.github.efogdev.mpris-timer.metainfo.xml -t $out/share/metainfo
    install -Dm644 misc/io.github.efogdev.mpris-timer.gschema.xml -t $out/share/glib-2.0/schemas
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = {
    description = "Timer app with seamless GNOME integration";
    homepage = "https://github.com/efogdev/mpris-timer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      stunkymonkey
      getchoo
    ];
    mainProgram = "mpris-timer";
  };
}
