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

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "eartag";
  version = "1.0.3";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "eartag";
    tag = finalAttrs.version;
    hash = "sha256-XyVKqkeaxy8bhrN6AhbnJpUSYETbY4DGHU7s2O71Wpc=";
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

  dependencies = with python3Packages; [
    aiofiles
    aiohttp
    pygobject3
    eyed3
    pillow
    mutagen
    pytaglib
    python-magic
    pyacoustid
    xxhash
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/World/eartag";
    description = "Simple music tag editor";
    changelog = "https://gitlab.gnome.org/World/eartag/-/releases/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "eartag";
    teams = [ lib.teams.gnome-circle ];
  };
})
