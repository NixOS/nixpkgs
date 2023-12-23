{ lib
, fetchFromGitLab
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, blueprint-compiler
, gtk4
, libadwaita
, libnotify
, webkitgtk_6_0
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook4
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "komikku";
  version = "1.32.0";

  format = "other";

  src = fetchFromGitLab {
    owner = "valos";
    repo = "Komikku";
    rev = "v${version}";
    hash = "sha256-aF7EByUQ6CO+rXfGz4ivU18N5sh0X8nGgJT94dCuN8c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    glib # for glib-compile-resources
    desktop-file-utils
    gobject-introspection
    blueprint-compiler
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libnotify
    webkitgtk_6_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    brotli
    colorthief
    dateparser
    emoji
    keyring
    lxml
    natsort
    piexif
    pillow
    pure-protobuf
    pygobject3
    python-magic
    rarfile
    requests
    unidecode
  ];

  # Tests require network
  doCheck = false;

  # Prevent double wrapping.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Manga reader for GNOME";
    homepage = "https://valos.gitlab.io/Komikku/";
    license = licenses.gpl3Plus;
    changelog = "https://gitlab.com/valos/Komikku/-/releases/v${version}";
    maintainers = with maintainers; [ chuangzhu infinitivewitch ];
  };
}
