{
  lib,
  fetchFromGitHub,
  glib,
  gnome-desktop,
  gobject-introspection,
  gtk4,
  libadwaita,
  python3Packages,
  wrapGAppsHook4,
  xvfb-run,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hyprmod";
  version = "0.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprmod";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MYxYraLMc9QecjKsoVxYO3wkeXDTgLJnBH131VVs0hI=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [
    glib # glib-compile-schemas for hatch build hook
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gnome-desktop
    gtk4
    libadwaita
  ];

  dependencies = with python3Packages; [
    hyprland-config
    hyprland-monitors
    hyprland-schema
    hyprland-socket
    hyprland-state
    pygobject3
  ];

  pythonRelaxDeps = [ "pygobject" ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    install -Dm0644 data/applications/io.github.bluemancz.hyprmod.desktop \
      -t $out/share/applications
    install -Dm0644 data/icons/hicolor/scalable/apps/io.github.bluemancz.hyprmod.svg \
      -t $out/share/icons/hicolor/scalable/apps
    install -Dm0644 data/metainfo/io.github.bluemancz.hyprmod.metainfo.xml \
      -t $out/share/metainfo
  '';

  pythonImportsCheck = [ "hyprmod" ];

  nativeCheckInputs = [
    python3Packages.pytest
    xvfb-run
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    # GnomeDesktop.XkbInfo aborts without the org.gnome.desktop.* schemas, which
    # are otherwise only wired up by the wrapper this phase runs before
    export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run -s '-screen 0 1024x768x24' pytest
    runHook postCheck
  '';

  meta = {
    description = "Native GTK4/libadwaita settings application for Hyprland";
    homepage = "https://github.com/BlueManCZ/hyprmod";
    changelog = "https://github.com/BlueManCZ/hyprmod/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprmod";
  };
})
