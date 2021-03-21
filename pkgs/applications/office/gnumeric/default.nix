{ lib, stdenv, fetchurl, pkg-config, intltool, perlPackages
, goffice, gnome3, wrapGAppsHook, gtk3, bison, python3Packages
, itstool
}:

let
  inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  pname = "gnumeric";
  version = "1.12.49";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0mzdhhpa7kwkc51l344g6vgqwaxkjdf03s7zasqh0bn3jpn75h4i";
  };

  configureFlags = [ "--disable-component" ];

  nativeBuildInputs = [ pkg-config intltool bison itstool wrapGAppsHook ];

  # ToDo: optional libgda, introspection?
  buildInputs = [
    goffice gtk3 gnome3.adwaita-icon-theme
    python pygobject3
  ] ++ (with perlPackages; [ perl XMLParser ]);

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "The GNOME Office Spreadsheet";
    license = lib.licenses.gpl2Plus;
    homepage = "http://projects.gnome.org/gnumeric/";
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
