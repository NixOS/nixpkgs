{ lib
, python3
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gobject-introspection
, glib
, gtk4
, librsvg
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, cava
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cavalier";
  version = "2023.01.29";
  format = "other";

  src = fetchFromGitHub {
    owner = "fsobolev";
    repo = pname;
    rev = version;
    hash = "sha256-6bvi73cFQHtIyD4d4+mqje0qkmG4wkahZ2ohda5RvRQ=";
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
    libadwaita
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  # Prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH ":" "${lib.makeBinPath [ cava ]}"
    )
  '';

  meta = with lib; {
    description = "Audio visualizer based on CAVA with customizable LibAdwaita interface";
    homepage = "https://github.com/fsobolev/cavalier";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
