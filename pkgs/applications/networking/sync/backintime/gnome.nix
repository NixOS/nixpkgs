{stdenv, fetchurl, makeWrapper, gettext, python2, python2Packages, gnome2, pkgconfig, pygobject, glib, libtool, backintime-common }:

stdenv.mkDerivation rec {
  inherit (backintime-common) version src sourceRoot installFlags meta;

  name = "backintime-gnome-${version}";

  buildInputs = [ makeWrapper gettext python2 python2Packages.dbus backintime-common python2Packages.pygtk python2Packages.notify gnome2.gnome_python ];

  preConfigure = "cd gnome";
  configureFlags = [ "--no-check" ];

  preFixup =
      ''
      # Make sure all Python files refer to $prefix/share/backintime
      # instead of config.get_app_path() which returns the path of the
      # 'common' module, not the path of the 'gnome' module.
      filelist=$(mktemp)
      find "$out/share/backintime/gnome" -name "*.py" -print0 > $filelist
      while IFS="" read -r -d "" file <&9; do
      substituteInPlace "$file" \
         --replace "glade_file = os.path.join(config.get_app_path()," \
                   "glade_file = os.path.join('$prefix/share/backintime'," \
         --replace "glade_file = os.path.join(self.config.get_app_path()," \
                   "glade_file = os.path.join('$prefix/share/backintime',"
      done 9< "$filelist"
      rm "$filelist"

      substituteInPlace "$out/bin/backintime-gnome" \
        --replace "=\"/usr/share" "=\"$prefix/share"

      wrapProgram "$out/bin/backintime-gnome" \
        --prefix PYTHONPATH : "${gnome2.gnome_python}/lib/python2.7/site-packages/gtk-2.0:${backintime-common}/share/backintime/common:$PYTHONPATH" \
        --prefix PATH : "${backintime-common}/bin:$PATH"
    '';

}
