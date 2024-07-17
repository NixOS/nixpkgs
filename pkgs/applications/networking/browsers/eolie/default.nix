{
  lib,
  fetchgit,
  meson,
  ninja,
  pkg-config,
  nix-update-script,
  python3,
  gtk3,
  libsecret,
  gst_all_1,
  webkitgtk,
  glib,
  glib-networking,
  gtkspell3,
  hunspell,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook3,
  gnome,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "eolie";
  version = "0.9.99";

  format = "other";
  doCheck = false;

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/eolie";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "077jww5mqg6bbqbj0j1gss2j3dxlfr2xw8bc43k8vg52drqg6g8w";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = with gst_all_1; [
    glib-networking
    gst-libav
    gst-plugins-base
    gst-plugins-ugly
    gstreamer
    gnome.gnome-settings-daemon
    gtk3
    gtkspell3
    hunspell
    libsecret
    webkitgtk
    glib
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyfxa
    beautifulsoup4
    cryptography
    pycairo
    pygobject3
    python-dateutil
    pycrypto
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  dontWrapGApps = true;
  preFixup = ''
    buildPythonPath "$out $propagatedBuildInputs"
    patchPythonScript "$out/libexec/eolie-sp"
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  strictDeps = false;

  meta = with lib; {
    description = "New GNOME web browser";
    mainProgram = "eolie";
    homepage = "https://gitlab.gnome.org/World/eolie";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
  };
}
