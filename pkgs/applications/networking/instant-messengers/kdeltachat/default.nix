{ lib
, mkDerivation
, fetchFromSourcehut
, cmake
, extra-cmake-modules
, pkg-config
, kirigami2
, libdeltachat
, qtimageformats
, qtmultimedia
}:

mkDerivation rec {
  pname = "kdeltachat";
  version = "unstable-2021-05-18";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "837336dc93b66912d48a3b7a2e8c1991b4d3650f";
    sha256 = "17ms6dcfdz0y24285fqpmgvw391bxrkagsiiy4g5cyp8gfppkgaj";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    kirigami2
    libdeltachat
    qtimageformats
    qtmultimedia
  ];

  meta = with lib; {
    description = "Delta Chat client using Kirigami framework";
    homepage = "https://git.sr.ht/~link2xt/kdeltachat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
