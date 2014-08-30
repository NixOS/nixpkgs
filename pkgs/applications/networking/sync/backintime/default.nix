{stdenv, fetchurl, makeWrapper, gettext, python2, python2Packages, gnome2, pkgconfig, pygobject, glib, libtool }:

let
  version = "1.0.36";

  src = fetchurl {
    url = "https://launchpad.net/backintime/1.0/${version}/+download/backintime-${version}.tar.gz";
    md5 = "28630bc7bd5f663ba8fcfb9ca6a742d8";
  };

  # because upstream tarball has no top-level directory.
  # https://bugs.launchpad.net/backintime/+bug/1359076
  sourceRoot = ".";

  genericBuildInputs = [ makeWrapper gettext python2 python2Packages.dbus ];

  installFlagsArray = [ "DEST=$(out)" ];

  meta = {
    homepage = https://launchpad.net/backintime;
    description = "Simple backup tool for Linux";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.DamienCassou ];
    platforms = stdenv.lib.platforms.linux;
    longDescription = ''
      Back In Time is a simple backup tool (on top of rsync) for Linux
      inspired from “flyback project” and “TimeVault”. The backup is
      done by taking snapshots of a specified set of directories.
    '';
  };

  common = stdenv.mkDerivation rec {
    inherit version src sourceRoot installFlagsArray meta;

    name = "backintime-common-${version}";

    buildInputs = genericBuildInputs;

    preConfigure = "cd common";

    dontAddPrefix = true;

    preFixup =
      ''
      substituteInPlace "$out/bin/backintime" \
        --replace "=\"/usr/share" "=\"$prefix/share"
      wrapProgram "$out/bin/backintime" \
        --prefix PYTHONPATH : "$PYTHONPATH"
    '';
  };

in
stdenv.mkDerivation rec {
  inherit version src sourceRoot installFlagsArray meta;

  name = "backintime-gnome-${version}";

  buildInputs = genericBuildInputs ++ [ common python2Packages.pygtk python2Packages.notify gnome2.gnome_python ];

  preConfigure = "cd gnome";
  configureFlagsArray = [ "--no-check" ];

  preFixup =
      ''
      substituteInPlace "$out/share/backintime/gnome/app.py" \
         --replace "glade_file = os.path.join(self.config.get_app_path()," \
                   "glade_file = os.path.join('$prefix/share/backintime',"
      substituteInPlace "$out/share/backintime/gnome/settingsdialog.py" \
        --replace "glade_file = os.path.join(self.config.get_app_path()," \
                  "glade_file = os.path.join('$prefix/share/backintime',"
      substituteInPlace "$out/bin/backintime-gnome" \
        --replace "=\"/usr/share" "=\"$prefix/share"
      wrapProgram "$out/bin/backintime-gnome" \
        --prefix PYTHONPATH : "${gnome2.gnome_python}/lib/python2.7/site-packages/gtk-2.0:${common}/share/backintime/common:$PYTHONPATH" \
        --prefix PATH : "$PATH"
    '';

}
