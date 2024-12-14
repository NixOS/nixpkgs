{
  stdenv,
  lib,
  meson,
  ninja,
  pkg-config,
  fetchFromGitHub,
  fetchpatch,
  dleyna-core,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "dleyna-connector-dbus";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "phako";
    repo = pname;
    rev = "v${version}";
    sha256 = "WDmymia9MD3BRU6BOCzCIMrz9V0ACRzmEGqjbbuUmlA=";
  };

  patches = [
    # Fix build with meson 1.2. We use the gentoo patch intead of the
    # usptream one because the latter only applies on the libsoup_3 based
    # merged dLeyna project.
    # https://gitlab.gnome.org/World/dLeyna/-/merge_requests/6
    (fetchpatch {
      url = "https://github.com/gentoo/gentoo/raw/4a0982b49a1d94aa785b05d9b7d256c26c499910/net-libs/dleyna-connector-dbus/files/meson-1.2.0.patch";
      sha256 = "sha256-/p2OaPO5ghWtPotwIir2TtcFF5IDFN9FFuyqPHevuFI=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dleyna-core
    glib
  ];

  meta = with lib; {
    description = "D-Bus API for the dLeyna services";
    homepage = "https://github.com/phako/dleyna-connector-dbus";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
    license = licenses.lgpl21Only;
  };
}
