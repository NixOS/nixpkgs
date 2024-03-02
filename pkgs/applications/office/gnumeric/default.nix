{ lib, stdenv, fetchurl, pkg-config, intltool, perlPackages
, goffice, gnome, wrapGAppsHook, gtk3, bison, python3Packages
, itstool
}:

let
  inherit (python3Packages) python pygobject3;
in stdenv.mkDerivation rec {
  pname = "gnumeric";
  version = "1.12.56";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "UaOPNaxbD3He+oueIL8uCFY3mPHLMzeamhdyb7Hj4bI=";
  };

  configureFlags = [ "--disable-component" ];

  nativeBuildInputs = [ pkg-config intltool bison itstool wrapGAppsHook ];

  # ToDo: optional libgda, introspection?
  buildInputs = [
    goffice gtk3 gnome.adwaita-icon-theme
    python pygobject3
  ] ++ (with perlPackages; [ perl XMLParser ]);

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "The GNOME Office Spreadsheet";
    license = lib.licenses.gpl2Plus;
    homepage = "http://projects.gnome.org/gnumeric/";
    platforms = platforms.unix;
    broken = with stdenv; isDarwin && isAarch64;
    maintainers = [ maintainers.vcunat ];
  };
}
