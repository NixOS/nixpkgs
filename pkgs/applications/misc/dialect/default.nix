{ lib
, fetchFromGitHub
, wrapGAppsHook4
, python3
, appstream-glib
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
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dialect";
  version = "2.2.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "dialect-app";
    repo = "dialect";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-+0qA+jFYrK3K3mJNvxTvnT/3q4c51H0KgEMjzvV34Zs=";
  };

  # FIXME: remove in next release
  postPatch = ''
    substituteInPlace dialect/providers/lingva.py \
      --replace-fail 'lingva.ml' 'lingva.dialectapp.org'
    substituteInPlace dialect/providers/libretrans.py \
      --replace-fail 'libretranslate.de' 'lt.dialectapp.org'
  '';

  nativeBuildInputs = [
    appstream-glib
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

  meta = with lib; {
    homepage = "https://github.com/dialect-app/dialect";
    description = "A translation app for GNOME";
    maintainers = with maintainers; [ aleksana ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "dialect";
  };
}
