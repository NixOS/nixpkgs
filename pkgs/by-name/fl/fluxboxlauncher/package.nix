{
  lib,
  fetchFromGitHub,
  python3,
  gtk3,
  wrapGAppsHook3,
  glibcLocales,
  gobject-introspection,
  gettext,
  pango,
  gdk-pixbuf,
  atk,
  fluxbox,
}:

python3.pkgs.buildPythonApplication {
  pname = "fluxboxlauncher";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = "fluxboxlauncher";
    rev = "0.2.1";
    hash = "sha256-bn+/iTeA/DcfpkV7hm6CEbOXl8LX5EYb0YXBBWYLkAg=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    pango
    gdk-pixbuf
    atk
    gettext
  ];

  buildInputs = [
    glibcLocales
    gtk3
    python3
    fluxbox
  ];

  makeWrapperArgs = [
    "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive"
    "--set CHARSET en_us.UTF-8"
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    pygobject3
  ];

  postInstall = ''
    install -Dm444 fluxboxlauncher.desktop -t $out/share/applications
    install -Dm444 fluxboxlauncher.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  meta = {
    description = "Gui editor (gtk) to configure applications launching on a fluxbox session";
    mainProgram = "fluxboxlauncher";
    homepage = "https://github.com/mothsART/fluxboxlauncher";
    maintainers = with lib.maintainers; [ mothsart ];
    license = lib.licenses.bsdOriginal;
    platforms = lib.platforms.linux;
  };
}
