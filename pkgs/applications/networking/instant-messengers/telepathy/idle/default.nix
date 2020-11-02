{ stdenv
, fetchurl
, glib
, dconf
, meson
, ninja
, pkg-config
, python3
, dbus-glib
, telepathy-glib
, libxslt
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "telepathy-idle";
  version = "0.2.2";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0py1qdpd6w4i5r37wgpx6fw10rbdcqnhkp7507kwpd5hbxgf51w3";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3 # for building GInterfaces
    libxslt # for xsltproc
    makeWrapper
  ];

  buildInputs = [
    glib
    telepathy-glib
    dbus-glib
  ];

  # For twisted tests
  # checkInputs = [
  #   (python3.withPackages (pp: with pp; [
  #     dbus-python

  #     twisted
  #     # Required by twisted
  #     pygobject3
  #     pyopenssl
  #     service-identity
  #   ]))
  # ];

  mesonFlags = [
    "-Dtwisted_tests=false" # two of those are timing out
  ];

  preFixup = ''
    wrapProgram "$out/libexec/telepathy-idle" \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "IRC connection manager for the Telepathy framework";
    license = licenses.lgpl21Only; # some files are 2.1-only, others 2.1-or later
    platforms = platforms.gnu ++ platforms.linux;
  };
}
