{ lib
, fetchFromGitea
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
  version = "1.36.0";

  format = "other";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "valos";
    repo = "Komikku";
    rev = "v${version}";
    hash = "sha256-sX/4Sez6gKSgaUJC7iW2BeVp0y9h64YqQi7FL5fzZ4o=";
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
    homepage = "https://apps.gnome.org/Komikku/";
    license = licenses.gpl3Plus;
    changelog = "https://codeberg.org/valos/Komikku/releases/tag/v${version}";
    maintainers = with maintainers; [ chuangzhu infinitivewitch ];
  };
}
