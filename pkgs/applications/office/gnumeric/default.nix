{ stdenv, fetchurl, pkgconfig, intltool, perlPackages
, goffice, gnome3, wrapGAppsHook, gtk3, bison, pythonPackages
, itstool, autoreconfHook
}:

let
  inherit (pythonPackages) python pygobject3;
in stdenv.mkDerivation rec {
  pname = "gnumeric";
  version = "1.12.45"; # TODO next release: remove gamma patch and autoreconfHook

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0c8dl1kvnj3g32qy3s92qpqpqfy0in59cx005gjvvzsflahav61h";
  };

  patches = stdenv.lib.optional stdenv.isDarwin
    # https://gitlab.gnome.org/GNOME/gnumeric/issues/402
    (fetchurl {
      name = "math-gamma.patch";
      url = "https://gitlab.gnome.org/GNOME/gnumeric/uploads/cf8d162bc719de92e97d01cb0ba5b637/ppp";
      sha256 = "17wiigs06qc86a1nghwcg3pcnpa28123jblgsxpy3j7drardgnlp";
    });

  configureFlags = [ "--disable-component" ];

  nativeBuildInputs = [ pkgconfig intltool bison itstool wrapGAppsHook ]
    ++ stdenv.lib.optional stdenv.isDarwin autoreconfHook;

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
