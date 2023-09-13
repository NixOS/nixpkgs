{ cmake
, cpptango
, fetchFromGitLab
, lib
, mariadb-connector-c
, pkg-config
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "tango-access-control";
  version = "2.20";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "TangoAccessControl";
    rev = "TangoAccessControl-Release-${version}";
    hash = "sha256-5LrF18o3CWveX4zoUhKB0tgIIVDXnhxL2UcYoL33r4g=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cpptango ];

  cmakeFlags = [
    "-DMySQL_LIBRARY_RELEASE=${mariadb-connector-c}/lib/mariadb/libmariadb${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DMySQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
    "-DMySQL_EXECUTABLE=${mariadb-connector-c}/bin/mariadb"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  preConfigure = ''
    cd TangoAccessControl
  '';

  meta = with lib; {
    description = "Access control device server for the Tango controls system";
    homepage = "https://www.tango-controls.org";
    changelog = "https://gitlab.com/tango-controls/cppTango/-/blob/${version}/RELEASE_NOTES.md";
    downloadPage = "https://gitlab.com/tango-controls/TangoSourceDistribution/-/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.unix;
  };

}
