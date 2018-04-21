{ stdenv, fetchurl, meson, ninja, pkgconfig, vala, gettext
, libxml2, desktop-file-utils, wrapGAppsHook
, glib, gtk3, libgtop, gnome3 }:

let
  pname = "gnome-usage";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0130bwinpkz307nalw6ndi5mk38k5g6jna4gbw2916d54df6a4nq";
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
