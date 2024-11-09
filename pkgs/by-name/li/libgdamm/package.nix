{ lib, stdenv, fetchurl, pkg-config, glibmm, libgda, libxml2, gnome
, mysqlSupport ? false
, postgresSupport ? false }:

let
  gda = libgda.override {
    inherit mysqlSupport postgresSupport;
  };
in stdenv.mkDerivation rec {
  pname = "libgdamm";
  version = "4.99.11";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1fyh15b3f8hmwbswalxk1g4l04yvvybksn5nm7gznn5jl5q010p9";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glibmm libxml2 ];
  propagatedBuildInputs = [ gda ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none"; # Should be odd-unstable but stable version has not been released yet.
    };
  };

  meta = with lib; {
    description = "C++ bindings for libgda";
    homepage = "https://www.gnome-db.org/";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
