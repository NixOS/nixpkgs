{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  libadwaita,
  gettext,
  glib,
  gobject-introspection,
  desktop-file-utils,
  appstream,
  appstream-glib,
  gtk4,
  librsvg,
  python3Packages,
  blueprint-compiler,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "eartag";
  version = "0.6.5";
  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "eartag";
    rev = version;
    hash = "sha256-sxVivQppX8KdkvHaW6xQ64Wi8Nfv5Rmwf4NADBDpOOo=";
  };

  postPatch = ''
    chmod +x ./build-aux/meson/postinstall.py
    patchShebangs ./build-aux/meson/postinstall.py
    substituteInPlace ./build-aux/meson/postinstall.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  nativeBuildInputs = [
    meson
    ninja
    glib
    desktop-file-utils
    appstream
    appstream-glib
    pkg-config
    gettext
    gobject-introspection
    wrapGAppsHook4
    blueprint-compiler
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gtk4; # for gtk4-update-icon-cache

  buildInputs = [
    librsvg
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    eyed3
    pillow
    mutagen
    pytaglib
    python-magic
    pyacoustid
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/eartag";
    description = "Simple music tag editor";
    # This seems to be using ICU license but we're flagging it to MIT license
    # since ICU license is a modified version of MIT and to prevent it from
    # being incorrectly identified as unfree software.
    license = licenses.mit;
    mainProgram = "eartag";
    maintainers = with maintainers; [ foo-dogsquared ];
    teams = [ teams.gnome-circle ];
  };
}
