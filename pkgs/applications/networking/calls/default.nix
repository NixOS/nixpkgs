{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, libhandy
, modemmanager
, gtk3
, gom
, gsound
, feedbackd
, callaudiod
, evolution-data-server
, glib
, folks
, desktop-file-utils
, appstream-glib
, libpeas
, libgdata
, dbus
, vala
, wrapGAppsHook
, xvfb-run
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, gobject-introspection
, gst_all_1
, sofia_sip
}:

stdenv.mkDerivation rec {
  pname = "calls";
  version = "42.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-ASKK9PB5FAD10CR5O+L2WgMjCzmIalithHL8jV0USiM=";
  };

  outputs = [ "out" "devdoc" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream-glib
    vala
    wrapGAppsHook
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [
    modemmanager
    libhandy
    evolution-data-server
    folks
    gom
    gsound
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    feedbackd
    callaudiod
    gtk3
    libpeas
    sofia_sip
  ];

  checkInputs = [
    dbus
    xvfb-run
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  # Disable until tests are fixed upstream https://gitlab.gnome.org/GNOME/calls/-/issues/258
  doCheck = false;

  checkPhase = ''
    runHook preCheck
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS=${folks}/share/gsettings-schemas/${folks.name} \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
    runHook postCheck
  '';

  meta = with lib; {
    description = "A phone dialer and call handler";
    longDescription = "GNOME Calls is a phone dialer and call handler. Setting NixOS option `programs.calls.enable = true` is recommended.";
    homepage = "https://source.puri.sm/Librem5/calls";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ craigem lheckemann tomfitzhenry ];
    platforms = platforms.linux;
  };
}
