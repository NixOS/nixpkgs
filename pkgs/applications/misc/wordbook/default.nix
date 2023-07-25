{ lib
, fetchFromGitHub
, python3
, meson
, ninja
, pkg-config
, glib
, gtk4
, libadwaita
, librsvg
, espeak-ng
, gobject-introspection
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wordbook";
  version = "unstable-2022-11-02";
  format = "other";

  src = fetchFromGitHub {
    owner = "fushinari";
    repo = "Wordbook";
    rev = "2d79e9e9ef21ba4b54d0b46c764a1481a06f0f1b";
    hash = "sha256-ktusZEQ7m8P0kiH09r3XC6q9bQCWVCn543IMLKmULDo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libadwaita
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    wn
  ];

  # prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH ":" "${lib.makeBinPath [ espeak-ng ]}"
      "''${gappsWrapperArgs[@]}"
    )
  '';

  meta = with lib; {
    description = "Offline English-English dictionary application built for GNOME";
    homepage = "https://github.com/fushinari/Wordbook";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
