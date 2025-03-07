{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  autoreconfHook,
  mono,
  gtk-sharp-3_0,
  dbus-sharp-1_0,
  dbus-sharp-glib-1_0,
}:

stdenv.mkDerivation rec {
  pname = "notify-sharp";
  version = "3.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Archive";
    repo = "notify-sharp";

    rev = version;
    sha256 = "1vm7mnmxdwrgy4mr07lfva8sa6a32f2ah5x7w8yzcmahaks3sj5m";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    mono
    gtk-sharp-3_0
    dbus-sharp-1_0
    dbus-sharp-glib-1_0
  ];

  dontStrip = true;

  postPatch = ''
    sed -i 's#^[ \t]*DOCDIR=.*$#DOCDIR=$out/lib/monodoc#' ./configure.ac
  '';

  meta = with lib; {
    description = "D-Bus for .NET";
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
