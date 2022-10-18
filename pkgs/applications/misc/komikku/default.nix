{ lib
, fetchFromGitLab
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gtk4
, libadwaita
, libnotify
, webkitgtk_5_0
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook4
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "komikku";
  version = "1.9.0";

  format = "other";

  src = fetchFromGitLab {
    owner = "valos";
    repo = "Komikku";
    rev = "v${version}";
    sha256 = "sha256-UFam3C9jZNuJvTlccyUvhp4z624hPByPhX7cPROv528=";
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
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libnotify
    webkitgtk_5_0
    gobject-introspection
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    beautifulsoup4
    brotli
    cloudscraper
    dateparser
    emoji
    keyring
    lxml
    python-magic
    natsort
    pillow
    pure-protobuf
    rarfile
    unidecode
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-steps
  ];

  # Tests require network
  doCheck = false;

  # Prevent double wrapping.
  dontWrapGApps = true;

  preCheck = ''
    # Step out of Meson’s build directory.
    cd ..
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "komikku";
    };
  };

  meta = with lib; {
    description = "Manga reader for GNOME";
    homepage = "https://valos.gitlab.io/Komikku/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
