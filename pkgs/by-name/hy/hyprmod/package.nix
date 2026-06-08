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
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hyprmod";
  version = "0.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprmod";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oO7tibfdaM6IgpZQEUItahtpSgFjlIffDyhcTBJiSRQ=";
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
    pygobject-stubs
  ];

  # nixpkgs ships pygobject 3.54.5, upstream pyproject pins >=3.56.2
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

  # tests require running Hyprland instance
  doCheck = false;

  meta = {
    description = "Native GTK4/libadwaita settings application for Hyprland";
    homepage = "https://github.com/BlueManCZ/hyprmod";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprmod";
  };
})
