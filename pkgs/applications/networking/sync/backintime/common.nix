{stdenv, fetchurl, makeWrapper, gettext, python2, python2Packages }:

stdenv.mkDerivation rec {
  version = "1.0.36";

  name = "backintime-common-${version}";

  src = fetchurl {
    url = "https://launchpad.net/backintime/1.0/${version}/+download/backintime-${version}.tar.gz";
    md5 = "28630bc7bd5f663ba8fcfb9ca6a742d8";
  };

  # because upstream tarball has no top-level directory.
  # https://bugs.launchpad.net/backintime/+bug/1359076
  sourceRoot = ".";

  buildInputs = [ makeWrapper gettext python2 python2Packages.dbus ];

  installFlags = [ "DEST=$(out)" ];

  preConfigure = "cd common";

  dontAddPrefix = true;

  preFixup =
    ''
    substituteInPlace "$out/bin/backintime" \
      --replace "=\"/usr/share" "=\"$prefix/share"
    wrapProgram "$out/bin/backintime" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PATH : "$prefix/bin:$PATH"
    '';

  meta = {
    homepage = https://launchpad.net/backintime;
    description = "Simple backup tool for Linux";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.DamienCassou ];
    platforms = stdenv.lib.platforms.all;
    longDescription = ''
      Back In Time is a simple backup tool (on top of rsync) for Linux
      inspired from “flyback project” and “TimeVault”. The backup is
      done by taking snapshots of a specified set of directories.
    '';
  };
}