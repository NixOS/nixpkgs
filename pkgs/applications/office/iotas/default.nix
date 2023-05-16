{ lib
, python3
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, glib
, gtk4
, librsvg
, libsecret
, libadwaita
, gtksourceview5
, webkitgtk_6_0
}:

python3.pkgs.buildPythonApplication rec {
  pname = "iotas";
<<<<<<< HEAD
  version = "0.2.2";
=======
  version = "0.1.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "cheywood";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-oThsyTsNM3283e4FViISdFzmeQnU7qXHh4xEJWA2fkc=";
=======
    hash = "sha256-IvKjvsHJdoFmDvsM1/kFPikYbBLUEQ57DKr1T+Jyw7w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libsecret
    libadwaita
    gtksourceview5
    webkitgtk_6_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pygtkspellcheck
    requests
    markdown-it-py
    linkify-it-py
<<<<<<< HEAD
    mdit-py-plugins
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # prevent double wrapping
  dontWrapGApps = true;
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Simple note taking with mobile-first design and Nextcloud sync";
    homepage = "https://gitlab.gnome.org/cheywood/iotas";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
