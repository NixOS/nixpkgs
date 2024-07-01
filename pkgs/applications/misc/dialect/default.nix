{ lib
, fetchFromGitHub
, wrapGAppsHook4
, python3
, blueprint-compiler
, desktop-file-utils
, meson
, ninja
, pkg-config
, glib
, gtk4
, gobject-introspection
, gst_all_1
, libsoup_3
, glib-networking
, libadwaita
, libsecret
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dialect";
  version = "2.4.1";
  pyproject = false; # built with meson

  src = fetchFromGitHub {
    owner = "dialect-app";
    repo = "dialect";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-WEeTdUdhDSfStu+rBYcuk6miuh5e0AsodbyF93Mg4mo=";
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
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  doCheck = false;

  # handle setup hooks better
  strictDeps = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/dialect-app/dialect";
    description = "Translation app for GNOME";
    maintainers = with lib.maintainers; [ aleksana ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "dialect";
  };
}
