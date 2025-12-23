{
  lib,
  fetchFromGitHub,
  wrapGAppsHook4,
  python3,
  blueprint-compiler,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk4,
  gobject-introspection,
  gst_all_1,
  libsoup_3,
  glib-networking,
  libadwaita,
  libsecret,
  libspelling,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dialect";
  version = "2.6.1";
  pyproject = false; # built with meson

  src = fetchFromGitHub {
    owner = "dialect-app";
    repo = "dialect";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-Gy5KlcY22ykoWUzVk6w46SLndOmEQxMCcvo1ClMq0LM=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libsoup_3
    glib-networking
    libadwaita
    libsecret
    libspelling
  ];

  dependencies = with python3.pkgs; [
    dbus-python
    gtts
    pygobject3
    beautifulsoup4
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    patchShebangs --update --host $out/share/dialect/search_provider
  '';

  doCheck = false;

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://dialectapp.org";
    description = "Translation app for GNOME";
    teams = [ lib.teams.gnome-circle ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "dialect";
  };
}
