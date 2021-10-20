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
}:

stdenv.mkDerivation rec {
  pname = "calls";
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "0igap5ynq269xqaky6fqhdg2dpsvxa008z953ywa4s5b5g5dk3dd";
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
    feedbackd
    callaudiod
    gtk3
    libpeas
    libgdata # required by some dependency transitively
  ];

  checkInputs = [
    dbus
    xvfb-run
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

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
    maintainers = with maintainers; [ craigem lheckemann ];
    platforms = platforms.linux;
  };
}
