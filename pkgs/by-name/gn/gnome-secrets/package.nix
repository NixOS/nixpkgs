{
  lib,
  meson,
  ninja,
  pkg-config,
  gettext,
  fetchFromGitLab,
  python3Packages,
  wrapGAppsHook4,
  opensc,
  gtk4,
  glib,
  gdk-pixbuf,
  gobject-introspection,
  desktop-file-utils,
  shared-mime-info,
  appstream-glib,
  libadwaita,
  gtksourceview5,
  xvfb-run,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-secrets";
  version = "12.0";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "secrets";
    tag = version;
    hash = "sha256-U+ez/rhaXROcLdXhFY992YzIRBCkR05hxkAYbWIpa/A=";
  };

  postPatch = ''
    substituteInPlace gsecrets/meson.build \
      --replace-fail \
        "join_paths(get_option('prefix'), get_option('libdir'), 'opensc-pkcs11.so')" \
        "'${lib.getLib opensc}/lib/opensc-pkcs11.so'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    shared-mime-info
    appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    glib
    gdk-pixbuf
    libadwaita
    gtksourceview5
  ];

  dependencies = with python3Packages; [
    pygobject3
    construct
    pyhibp
    pykcs11
    pykeepass
    pyotp
    validators
    yubico
    zxcvbn-rs-py
  ];

  doCheck = true;

  nativeCheckInputs = [
    python3Packages.pytest
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck
    env \
      GTK_A11Y=none \
      PYTHONPATH="$out/${python3Packages.python.sitePackages}:$PYTHONPATH" \
      XDG_DATA_DIRS="$out/share/gsettings-schemas/$name:$XDG_DATA_DIRS" \
      xvfb-run meson test --print-errorlogs
    runHook postCheck
  '';

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Password manager for GNOME which makes use of the KeePass v.4 format";
    homepage = "https://gitlab.gnome.org/World/secrets";
    changelog = "https://gitlab.gnome.org/World/secrets/-/releases/${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "secrets";
  };
}
