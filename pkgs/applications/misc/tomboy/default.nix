{ stdenv, fetchurl, itstool, intltool, pkgconfig
, libxml2, gnome2, atk, gtk2, glib
, mono, mono-addins, dbus-sharp-2_0, dbus-sharp-glib-2_0, gnome-sharp, gtk-sharp-2_0
, makeWrapper, lib}:

let
  version = "1.15.9";
in

stdenv.mkDerivation {
  name = "tomboy-${version}";

  src = fetchurl {
    url = "https://github.com/tomboy-notes/tomboy/releases/download/${version}/tomboy-${version}.tar.xz";
    sha256 = "0j5jmd079bm2fydqaic5ymbfdxna3qlx6fkp2mqhgcdr7prsbl3q";
  };

  buildInputs = [ itstool intltool pkgconfig
    libxml2 gnome2.GConf atk gtk2
    mono mono-addins dbus-sharp-2_0 dbus-sharp-glib-2_0 gnome-sharp gtk-sharp-2_0
    makeWrapper ];

  postInstall = ''
    makeWrapper "${mono}/bin/mono" "$out/bin/tomboy" \
      --add-flags "$out/lib/tomboy/Tomboy.exe" \
      --prefix MONO_GAC_PREFIX : ${dbus-sharp-2_0} \
      --prefix MONO_GAC_PREFIX : ${dbus-sharp-glib-2_0} \
      --prefix MONO_GAC_PREFIX : ${gtk-sharp-2_0} \
      --prefix MONO_GAC_PREFIX : ${gnome-sharp} \
      --prefix MONO_GAC_PREFIX : ${mono-addins} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ glib gtk-sharp-2_0 gtk-sharp-2_0.gtk gnome2.GConf ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Tomboy;
    description = "A simple note-taking application with synchronization";
    platforms = platforms.linux;
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with maintainers; [ stesie ];
  };
}
