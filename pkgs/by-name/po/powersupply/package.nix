{
  lib,
  python3,
  fetchFromGitLab,
  desktop-file-utils,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "powersupply";
  version = "0.10.1";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "powersupply";
    rev = version;
    hash = "sha256-sPdtrm2WQYjPu+1bb0ltBiqS9t8FFvbgRdGe1PEthy0=";
  };

  postPatch = ''
    substituteInPlace build-aux/meson/postinstall.py \
      --replace 'gtk-update-icon-cache' 'gtk4-update-icon-cache'
  '';

  nativeBuildInputs = [
    desktop-file-utils
    gtk4 # for gtk4-update-icon-cache
    gobject-introspection # Without this, launching the app on aarch64-linux results in ValueError: Namespace Gtk not available
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  dependencies = with python3.pkgs; [
    pygobject3
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Graphical app to display power status of mobile Linux platforms";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/powersupply";
    license = licenses.mit;
    mainProgram = "powersupply";
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
}
