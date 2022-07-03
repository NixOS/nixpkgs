{ lib
, stdenv
, fetchFromGitLab
, alsa-lib
, boost
, dbus-glib
, ganv
, glibmm
, gtkmm2
, libjack2
, pkg-config
, python3
, wafHook
}:

stdenv.mkDerivation rec {
  pname = "patchage";
  version = "1.0.4";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-feQXACsn2i2pJXs0EA9tIbtpl9Lxx5K4G7eG5VWuDV0=";
    fetchSubmodules = true;
  };

  buildInputs = [
    alsa-lib
    boost
    dbus-glib
    ganv
    glibmm
    gtkmm2
    libjack2
    pkg-config
    python3
    wafHook
  ];

  meta = {
    description = "Modular patch bay for Jack and ALSA systems";
    homepage = "https://drobilla.net/software/patchage.html";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
