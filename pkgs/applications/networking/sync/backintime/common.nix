{stdenv, fetchurl, makeWrapper, gettext, python3, python3Packages, rsync, cron, openssh, sshfsFuse, encfs }:

stdenv.mkDerivation rec {
  version = "1.1.6";

  name = "backintime-common-${version}";

  src = fetchurl {
    url = "https://launchpad.net/backintime/1.1/${version}/+download/backintime-${version}.tar.gz";
    sha256 = "04yw1v6h959mmvc67mhh0km7vkxjzb7j1mniv5xfjdy27ryii1ig";
  };

  buildInputs = [ makeWrapper gettext python3 python3Packages.dbus python3Packages.keyring openssh cron rsync sshfsFuse encfs ];

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
