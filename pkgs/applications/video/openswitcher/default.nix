{ lib
, fetchgit
, gtk3
, glib
, gobject-introspection
, meson
, pkg-config
, python3
, stdenv
, libhandy
, ninja
}:

stdenv.mkDerivation rec {
  name = "openswitcher-${version}";
  version="0.5.0";

  src = fetchgit {
    url = "https://git.sr.ht/~martijnbraam/pyatem";
    rev = "${version}";
    sha256 = "a7XdoPpFARx4wKt6osTb4WZpFsG4o+/R1+x83dDB3AQ=";
  };

  buildInputs = [
    gtk3
    libhandy
  ];

  postPatch = ''
    # FIXME: Is the postinstall script important? it doesn't work.
    #patchShebangs build-aux/meson/postinstall.py
    sed -i -e '/build-aux\/meson\/postinstall\.py/d' meson.build
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    glib
    gobject-introspection
    python3.pkgs.pygobject3
  ];

  meta = with lib; {
    description = "Open Switcher (for Blackmagic ATEM video mixers)";
    homepage = "https://openswitcher.org/";
    license = licenses.lgpl3;
    broken = true;
  };
}
