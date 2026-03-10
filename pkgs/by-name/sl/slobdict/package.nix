{
  lib,
  blueprint-compiler,
  meson,
  ninja,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook4,
  gobject-introspection,
  pkg-config,
  gtk4,
  webkitgtk_6_0,
  glib,
  libadwaita,
  libzim,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "slobdict";
  version = "1.0.0";

  pyproject = false; # built with meson

  src = fetchFromGitHub {
    owner = "MuntashirAkon";
    repo = "SlobDict";
    tag = finalAttrs.version;
    hash = "sha256-V6EmEpxUMZUN9lHSNs4nZBZI2QNxUUWWODukm01lYxY=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    glib
    libadwaita
    libzim
    webkitgtk_6_0
  ];

  dependencies = with python3Packages; [
    pygobject3
    pyglossary

    # Optional deps of pyglossary
    pyyaml
    beautifulsoup4
    biplist
    # colorize-pinyin not packaged
    html5lib
    marisa-trie
    mistune
    polib
    prompt-toolkit
    pymorphy3
    # python-romkan-ng not packaged
    xxhash
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  postInstall = ''
    chmod +x $out/bin/slobdict
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  strictDeps = true;

  meta = {
    homepage = "https://github.com/MuntashirAkon/SlobDict";
    description = "Modern, lightweight GTK 4 dictionary app";
    mainProgram = "slobdict";
    maintainers = with lib.maintainers; [ linsui ];
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
  };
})
