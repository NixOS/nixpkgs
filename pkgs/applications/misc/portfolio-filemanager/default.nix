{ lib
, python3
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gtk3
, libhandy
, librsvg
, meson
, ninja
, pkg-config
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "portfolio";
  version = "0.9.14";

  format = "other";

  src = fetchFromGitHub {
    owner = "tchx84";
    repo = "Portfolio";
    rev = "v${version}";
    hash = "sha256-mrb202ON0B6VlY+U+jN0jJmbT36jQ8krNnuODynaCUA=";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    gtk3
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gobject-introspection
    libhandy
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  checkPhase = ''
    meson test
  '';

  postInstall = ''
    ln -s dev.tchx84.Portfolio "$out/bin/portfolio"
  '';

  meta = with lib; {
    description = "A minimalist file manager for those who want to use Linux mobile devices";
    homepage = "https://github.com/tchx84/Portfolio";
    changelog = "https://github.com/tchx84/Portfolio/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
