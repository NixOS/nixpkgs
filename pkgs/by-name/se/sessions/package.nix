{
  lib,
  blueprint-compiler,
  buildGoModule,
  cairo,
  desktop-file-utils,
  fetchFromGitHub,
  gdk-pixbuf,
  gettext,
  glib,
  gobject-introspection,
  graphene,
  gst_all_1,
  gtk4,
  libadwaita,
  pango,
  symlinkJoin,
  wrapGAppsHook4,
}:

buildGoModule (finalAttrs: {
  pname = "sessions";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "pojntfx";
    repo = "sessions";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pcIE93Jt7moWgSlulCk5lrkwSj10w75agsyffZI9zDo=";
  };

  vendorHash = "sha256-tMN7hF1vhUL0vWf3LJKyVYjMv+mgCw1bfUpGhQcL3gM=";

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gettext
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  passthru = {
    libraryPath = symlinkJoin {
      name = "sessions-puregotk-lib";
      paths = [
        cairo
        gdk-pixbuf
        glib.out
        graphene
        gtk4
        libadwaita
        pango.out
      ];
    };
  };

  ldflags = [
    "-s"
    "-w"
  ];

  postPatch = ''
    substituteInPlace main.go --replace-fail '/usr/share/locale' "$out/share/locale"
    substituteInPlace po/index.go --replace-fail '/usr/share/gettext/its/metainfo.its' ${gettext}/share/gettext-*/its/metainfo.its
    substituteInPlace po/index.go --replace-fail '/usr/share/gettext/its/gschema.its' '${glib.out}/share/gettext/its/gschema.its'
  '';

  preBuild = ''
    export FLATPAK_ID="com.pojtinger.felicitas.Sessions"
    go generate ./...
  '';

  postInstall = ''
    wrapProgram $out/bin/sessions \
      --set-default PUREGOTK_LIB_FOLDER ${finalAttrs.passthru.libraryPath}/lib \
      ''${gappsWrapperArgs[@]}

    # Adapted from https://github.com/pojntfx/sessions/blob/v0.1.15/com.pojtinger.felicitas.Sessions.json
    desktop-file-install --dir=$out/share/applications assets/meta/com.pojtinger.felicitas.Sessions.desktop
    install -Dm444 assets/resources/metainfo.xml $out/share/metainfo/com.pojtinger.felicitas.Sessions.metainfo.xml
    install -Dm444 assets/meta/icon.svg $out/share/icons/hicolor/scalable/apps/com.pojtinger.felicitas.Sessions.svg
    install -Dm444 assets/meta/icon-symbolic.svg $out/share/icons/hicolor/symbolic/apps/com.pojtinger.felicitas.Sessions-symbolic.svg
    mkdir -p $out/share/locale && (cd po && find . -name "*.mo" -exec cp --parents {} $out/share/locale/ ';')
    install -Dm444 assets/resources/index.gschema.xml $out/share/glib-2.0/schemas/com.pojtinger.felicitas.Sessions.gschema.xml
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = {
    description = "Focus with timed work intervals";
    changelog = "https://github.com/pojntfx/sessions/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/pojntfx/sessions/";
    license = lib.licenses.agpl3Plus;
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "sessions";
  };
})
