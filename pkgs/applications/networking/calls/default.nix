{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, libhandy
, modemmanager
, gtk3
, gom
, gsound
, evolution-data-server
, folks
, desktop-file-utils
, libpeas
, dbus
, vala
, wrapGAppsHook
, xorg
, xvfb_run
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "calls";
  version = "0.1.2";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "calls";
    rev = "v${version}";
    sha256 = "105r631a0rva1k1fa50lravsfk5dd3f0k3gfc7lvpn2jkd99s1g6";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    desktop-file-utils
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    modemmanager
    libhandy
    evolution-data-server
    folks
    gom
    gsound
    gtk3
    libhandy
    libpeas
  ];

  checkInputs = [
    dbus
    xvfb_run
  ];

  mesonFlags = [
    # docs fail to build
    # https://source.puri.sm/Librem5/calls/issues/99
    "-Dgtk_doc=false"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    NO_AT_BRIDGE=1 \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "A phone dialer and call handler";
    homepage = "https://source.puri.sm/Librem5/calls";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ craigem lheckemann ];
    platforms = platforms.linux;
  };
}
