{ lib, stdenv, fetchFromGitHub
, autoconf, autoconf-archive, automake, glib, intltool, libtool, pkg-config
, gnome-desktop, gnupg, gtk3, udisks
}:

stdenv.mkDerivation rec {
  pname = "eos-installer";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "endlessm";
    repo = "eos-installer";
    rev = "Release_${version}";
    sha256 = "1nl6vim5dd83kvskmf13xp9d6zx39fayz4z0wqwf7xf4nwl07gwz";
    fetchSubmodules = true;
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoconf autoconf-archive automake glib intltool libtool pkg-config
  ];
  buildInputs = [ gnome-desktop gtk3 udisks ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--libexecdir=${placeholder "out"}/bin"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  # These are for runtime, so can't be discovered from PATH, which
  # is constructed from nativeBuildInputs.
  GPG_PATH = "${gnupg}/bin/gpg";
  GPGCONF_PATH = "${gnupg}/bin/gpgconf";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/endlessm/eos-installer";
    description = "Installer UI which writes images to disk";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
  };
}
