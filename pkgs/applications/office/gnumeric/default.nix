{ stdenv, fetchurl, pkgconfig, intltool, perlPackages
, goffice, gnome3, wrapGAppsHook, gtk3, bison, pythonPackages
, itstool
}:

let
  inherit (pythonPackages) python pygobject3;
in stdenv.mkDerivation rec {
  pname = "gnumeric";
  version = "1.12.44";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0147962c6ybdsj57rz95nla0rls7g545wc2n7pz59zmzyd5pksk0";
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
    homepage = http://projects.gnome.org/gnumeric/;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
