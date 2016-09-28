{stdenv, fetchFromGitHub, makeWrapper, gettext, python3Packages, rsync, cron, openssh, sshfsFuse, encfs }:

let
  inherit (python3Packages) python dbus-python keyring;
in stdenv.mkDerivation rec {
  version = "1.1.12";

  name = "backintime-common-${version}";

  src = fetchFromGitHub {
    owner = "bit-team";
    repo = "backintime";
    rev = "v${version}";
    sha256 = "0n3x48wa8aa7i8fff85h3b5h3xpabk51ld0ymy3pkqh0krfgs59a";
  };

  buildInputs = [ makeWrapper gettext python dbus-python keyring openssh cron rsync sshfsFuse encfs ];

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
    homepage = https://github.com/bit-team/backintime;
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
