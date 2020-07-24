{ stdenv, fetchurl, pkgconfig, intltool, perlPackages
, goffice, gnome3, wrapGAppsHook, gtk3, bison, python3Packages
, itstool
}:

let
  inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  pname = "gnumeric";
  version = "1.12.47";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1khrf72kiq50y8b5prbj2207k9shn36h2b2i588cc4wa28s9y5a0";
  };

  configureFlags = [ "--disable-component" ];

  nativeBuildInputs = [ pkgconfig intltool bison itstool wrapGAppsHook ];

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

  meta = with stdenv.lib; {
    description = "The GNOME Office Spreadsheet";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = "http://projects.gnome.org/gnumeric/";
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
