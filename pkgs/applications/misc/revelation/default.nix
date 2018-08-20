{ stdenv, fetchurl, pkgconfig, python2Packages, gnome2, intltool }:

stdenv.mkDerivation rec {
  name = "revelation-${version}";
  version = "0.4.14";

  src = fetchurl {
    url = "https://bitbucket.org/erikg/revelation/downloads/${name}.tar.bz2";
    sha256 = "2ab3d1d8bcc2f441feb58122ee6a0fe4070412228194843a180a7b1c9e910019";
  };

  patches = [ ./remove-randpool.patch ];

  buildInputs = [ gnome2.GConf intltool ];

  nativeBuildInputs = [
    python2Packages.wrapPython
    pkgconfig
  ];

  propagatedBuildInputs = with python2Packages; [
    pygtk pygobject2 pycrypto dbus-python gnome2.gnome_python python2Packages.cracklib
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0) $(pkg-config --cflags pygtk-2.0)"
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "A password manager for the GNOME desktop";
    homepage = https://revelation.olasagasti.info/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ trizinix ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
