{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  intltool,
  pkg-config,
  wrapGAppsHook3,
  gtkmm3,
  libuuid,
  poppler,
  qpdf,
}:

stdenv.mkDerivation rec {
  pname = "pdfslicer";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "junrrein";
    repo = "pdfslicer";
    tag = "v${version}";
    fetchSubmodules = true;
    sha256 = "0sja0ddd9c8wjjpzk2ag8q1lxpj09adgmhd7wnsylincqnj2jyls";
  };

  postPatch = ''
    # Don't build tests, vendored catch doesn't build with latest glibc.
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory (tests)" ""
  '';

  nativeBuildInputs = [
    cmake
    gettext
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    libuuid
    poppler
    qpdf
  ];

  CXXFLAGS =
    # Pending upstream compatibility with GCC 13
    lib.optional (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "13") "-Wno-changes-meaning";

  meta = with lib; {
    description = "Simple application to extract, merge, rotate and reorder pages of PDF documents";
    homepage = "https://junrrein.github.io/pdfslicer/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
