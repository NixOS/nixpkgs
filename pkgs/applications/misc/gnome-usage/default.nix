{ stdenv, fetchurl, meson, ninja, pkgconfig, vala, gettext
, libxml2, desktop-file-utils, wrapGAppsHook
, glib, gtk3, libgtop, gnome3 }:

let
  pname = "gnome-usage";
  version = "3.30.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0f1vccw916az8hzsqmx6f57jvl68s3sbd3qk4rpwn42ks1v7nmsh";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala gettext libxml2 desktop-file-utils wrapGAppsHook ];

  buildInputs = [ glib gtk3 libgtop gnome3.defaultIconTheme ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.sh
    patchShebangs build-aux/meson/postinstall.sh
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
