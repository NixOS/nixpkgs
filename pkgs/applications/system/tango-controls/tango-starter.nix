{ cmake
, cpptango
, fetchFromGitLab
, lib
, pkg-config
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "tango-starter";
  version = "8.1";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "starter";
    rev = "Starter-${version}";
    hash = "sha256-pO43OFYUcL9kePR0ixiR4GBWKJmD3xiqp7kCZUAm/Y4=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cpptango ];

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  meta = with lib; {
    description = "Starter device server for the Tango controls system";
    homepage = "https://www.tango-controls.org";
    changelog = "https://gitlab.com/tango-controls/cppTango/-/blob/${version}/RELEASE_NOTES.md";
    downloadPage = "https://gitlab.com/tango-controls/TangoSourceDistribution/-/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.unix;
  };

}
