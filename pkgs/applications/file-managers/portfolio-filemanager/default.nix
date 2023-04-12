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
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "portfolio";
  version = "0.9.15";

  format = "other";

  src = fetchFromGitHub {
    owner = "tchx84";
    repo = "Portfolio";
    rev = "v${version}";
    hash = "sha256-/OwHeeUjpjm35O7mySoAfKt7Rsp1EK2WE+tfiV3oiQg=";
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
    gtk3
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

  passthru = {
    updateScript = nix-update-script {
      attrPath = "portfolio-filemanager";
    };
  };

  meta = with lib; {
    description = "A minimalist file manager for those who want to use Linux mobile devices";
    homepage = "https://github.com/tchx84/Portfolio";
    changelog = "https://github.com/tchx84/Portfolio/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda chuangzhu ];
  };
}
