{ cmake
, cpptango
, fetchFromGitLab
, lib
, mariadb-connector-c
, pkg-config
, stdenv
, systemd
}:
stdenv.mkDerivation rec {
  pname = "tango-database";
  version = "5.22";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "TangoDatabase";
    rev = "Database-Release-${version}";
    hash = "sha256-SibxtXL7DKQGua8VEr6hd/5sRjQUIWURIS3MxQ13Qfc=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cpptango ] ++ lib.optional stdenv.isLinux systemd;

  cmakeFlags = [
    "-DMySQL_LIBRARY_RELEASE=${mariadb-connector-c}/lib/mariadb/libmariadb${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DMySQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
    "-DMySQL_EXECUTABLE=${mariadb-connector-c}/bin/mariadb"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  # To build proper systemd services for Tango, we need a way to tell when the DB service is started.
  # This patch adds systemd support for this.
  patches = lib.optional stdenv.isLinux ./sd_notify_cmake.patch;

  meta = with lib; {
    description = "Database server for the Tango controls system";
    homepage = "https://www.tango-controls.org";
    changelog = "https://gitlab.com/tango-controls/cppTango/-/blob/${version}/RELEASE_NOTES.md";
    downloadPage = "https://gitlab.com/tango-controls/TangoSourceDistribution/-/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.unix;
  };

}
