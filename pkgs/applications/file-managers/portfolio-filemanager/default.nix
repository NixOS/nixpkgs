{ lib
, python3
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gtk3
<<<<<<< HEAD
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, wrapGAppsHook4
=======
, libhandy
, librsvg
, meson
, ninja
, pkg-config
, wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "portfolio";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.9.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "other";

  src = fetchFromGitHub {
    owner = "tchx84";
    repo = "Portfolio";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ahVrOyyF/7X19ZJcHQ4YbC+4b96CPEnns7TUAFCvKao=";
=======
    hash = "sha256-/OwHeeUjpjm35O7mySoAfKt7Rsp1EK2WE+tfiV3oiQg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
<<<<<<< HEAD
    gobject-introspection
    gtk3 # For gtk-update-icon-cache
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  # Prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
=======
  passthru = {
    updateScript = nix-update-script {
      attrPath = "portfolio-filemanager";
    };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
