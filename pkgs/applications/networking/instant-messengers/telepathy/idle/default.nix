{ lib, stdenv, fetchurl, glib, dconf, pkg-config, dbus-glib, telepathy-glib, python2, libxslt, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "telepathy-idle";
  version = "0.2.0";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1argdzbif1vdmwp5vqbgkadq9ancjmgdm2ncp0qfckni715ss4rh";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ glib telepathy-glib dbus-glib libxslt python2 (lib.getLib dconf) ];

  preFixup = ''
    wrapProgram "$out/libexec/telepathy-idle" \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules"
  '';

  meta = {
    description = "IRC connection manager for the Telepathy framework";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
  };
}
