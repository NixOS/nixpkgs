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
, xorg
, xvfb_run
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "calls";
  version = "unstable-2019-10-29";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "calls";
    rev = "9fe575053d8f01c3a76a6c20d39f0816166d5afd";
    sha256 = "01inx4mvrzvklwrfryw5hw9p89v8cn78m3qmv97g7a3v0h5c0n35";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    desktop-file-utils
    vala
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
    homepage = https://source.puri.sm/Librem5/calls;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ craigem lheckemann ];
    platforms = platforms.linux;
  };
}
