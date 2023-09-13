{ cmake
, cpptango
, fetchFromGitLab
, lib
, pkg-config
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "tango-admin";
  version = "1.19";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "tango_admin";
    rev = "Release_${version}";
    hash = "sha256-ae56c+RuMT8FlnAtAs3FrtkRFCySE8w6V/cTUi4TMp8=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cpptango ];

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  meta = with lib; {
    description = "Admin device server for the Tango controls system";
    homepage = "https://www.tango-controls.org";
    changelog = "https://gitlab.com/tango-controls/cppTango/-/blob/${version}/RELEASE_NOTES.md";
    downloadPage = "https://gitlab.com/tango-controls/TangoSourceDistribution/-/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.unix;
  };

}
