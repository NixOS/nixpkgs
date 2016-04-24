{ stdenv, fetchurl, autoconf, automake, gettext, intltool, libtool, pkgconfig,
  libXtst, cheetah, libXScrnSaver, xorg,
  glib, glibmm,
  gtk, gtkmm,
  atk,
  pango, pangomm,
  cairo, cairomm,
  dbus, dbus_glib,
  GConf, gconfmm,
  gdome2, gstreamer, libsigcxx }:

stdenv.mkDerivation rec {
  version = "1.10.6";
  name = "workrave-${version}";

  src = let
    version_ = with stdenv.lib;
      concatStringsSep "_" (splitString "." version);
  in fetchurl {
    name = "${name}.tar.gz";
    url = "http://github.com/rcaelers/workrave/archive/v${version_}.tar.gz";
    sha256 = "0q2p83n33chbqzdcdm7ykfsy73frfi6drxzm4qidxwzpzsxrysgq";
  };

  buildInputs = [
    autoconf automake gettext intltool libtool pkgconfig libXtst cheetah
    libXScrnSaver

    glib glibmm gtk gtkmm atk pango pangomm cairo cairomm
    dbus dbus_glib GConf gconfmm gdome2 gstreamer libsigcxx xorg.libICE xorg.libSM
  ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "A program to help prevent Repetitive Strain Injury";
    longDescription = ''
      Workrave is a program that assists in the recovery and prevention of
      Repetitive Strain Injury (RSI). The program frequently alerts you to
      take micro-pauses, rest breaks and restricts you to your daily limit.
    '';
    homepage = http://www.workrave.org/;
    downloadPage = https://github.com/rcaelers/workrave/releases;
    license = licenses.gpl3;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.linux;
  };
}
