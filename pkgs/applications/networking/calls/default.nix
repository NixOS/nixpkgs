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
, desktop-file-utils
, libpeas
, dbus
, xorg
, xvfb_run
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "calls-unstable";
  version = "2019-10-09";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "4b4cfa04266ebbe2f3da5abd9624ea07aa159fea";
    sha256 = "0qvnddjpkh6gsywzdi24lmjlbwi0q54m1xa6hiaf1ch1j7kcv8fr";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    desktop-file-utils
  ];

  buildInputs = [
    modemmanager
    libhandy
    evolution-data-server
    gom
    gsound
    gtk3
    libhandy
    libpeas
    libxml2
  ];

  checkInputs = [
    dbus
    xvfb_run
    xorg.xauth
  ];

  mesonFlags = [
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
