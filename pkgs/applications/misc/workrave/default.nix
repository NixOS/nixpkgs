{ stdenv, fetchFromGitHub, fetchpatch
, autoconf, automake, gettext, intltool, libtool, pkgconfig
, libICE, libSM, libXScrnSaver, libXtst, cheetah
, glib, glibmm, gtk, gtkmm, atk, pango, pangomm, cairo, cairomm
, dbus, dbus_glib, GConf, gconfmm, gdome2, gstreamer, libsigcxx }:

stdenv.mkDerivation rec {
  name = "workrave-${version}";
  version = "1.10.7";

  src = let
  in fetchFromGitHub {
    sha256 = "1mxg882rfih7xzadrpj51m9r33f6s3rzwv61nfwi94vzd68qjnxb";
    rev = with stdenv.lib;
      "v" + concatStringsSep "_" (splitString "." version);
    repo = "workrave";
    owner = "rcaelers";
  };

  patches = [
    # Building with gtk{,mm}3 works just fine, but let's be conservative for once:
    (fetchpatch {
      name = "workrave-fix-compilation-with-gtk2.patch";
      url = "https://github.com/rcaelers/workrave/commit/"
        + "271efdcd795b3592bfede8b1af2162af4b1f0f26.patch";
      sha256 = "1a3d4jj8516m3m24bl6y8alanl1qnyzv5dv1hz5v3hjgk89fj6rk";
    })
  ];

  nativeBuildInputs = [
    autoconf automake gettext intltool libtool pkgconfig
  ];
  buildInputs = [
    libICE libSM libXScrnSaver libXtst cheetah
    glib glibmm gtk gtkmm atk pango pangomm cairo cairomm
    dbus dbus_glib GConf gconfmm gdome2 gstreamer libsigcxx
  ];

  preConfigure = "./autogen.sh";

  enableParallelBuilding = true;

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
    maintainers = with maintainers; [ nckx prikhi ];
    platforms = platforms.linux;
  };
}
