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
  pname = "tango-test";
  version = "3.8";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "TangoTest";
    rev = version;
    hash = "sha256-PJA0OCoqn31W9VelMz29fdVuJcq//lMbbJ/7xzbi1mw=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cpptango ];

  meta = with lib; {
    description = "Test device server for the Tango controls system";
    homepage = "https://www.tango-controls.org";
    changelog = "https://gitlab.com/tango-controls/cppTango/-/blob/${version}/RELEASE_NOTES.md";
    downloadPage = "https://gitlab.com/tango-controls/TangoSourceDistribution/-/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.unix;
  };

}
