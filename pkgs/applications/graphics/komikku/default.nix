{ lib
, fetchFromGitLab
, fetchpatch
, desktop-file-utils
, gettext
, glib
, gobject-introspection
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
<<<<<<< HEAD
  version = "1.23.0";
=======
  version = "1.19.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "other";

  src = fetchFromGitLab {
    owner = "valos";
    repo = "Komikku";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-duWAOod2co62NJ5Jk+7eWTf2LcfV5ZbFw0BhrbdGdUY=";
=======
    hash = "sha256-4XhcmK9Dgk82ExzugY4SGRfWYC+IgCAxWS+cBURgT2o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    webkitgtk_6_0
<<<<<<< HEAD
=======
    gobject-introspection
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    piexif
    pillow
    pure-protobuf
    rarfile
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
<<<<<<< HEAD
    updateScript = nix-update-script { };
=======
    updateScript = nix-update-script {
      attrPath = "komikku";
    };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Manga reader for GNOME";
    homepage = "https://valos.gitlab.io/Komikku/";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    changelog = "https://gitlab.com/valos/Komikku/-/releases/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ chuangzhu infinitivewitch ];
  };
}
