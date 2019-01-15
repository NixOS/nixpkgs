{ stdenv, fetchurl, pkgconfig, intltool, perlPackages
, goffice, gnome3, makeWrapper, gtk3, bison, pythonPackages
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

  nativeBuildInputs = [ pkgconfig intltool bison itstool makeWrapper ];

  # ToDo: optional libgda, introspection?
  buildInputs = [
    goffice gtk3 gnome3.defaultIconTheme
    python pygobject3
  ] ++ (with perlPackages; [ perl XMLParser ]);

  enableParallelBuilding = true;

  preFixup = ''
    for f in "$out"/bin/gnumeric-*; do
      wrapProgram $f \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        ${stdenv.lib.optionalString (!stdenv.isDarwin) "--prefix GIO_EXTRA_MODULES : '${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules'"}
    done
  '';

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
