{ cmake, extra-cmake-modules, fetchFromGitLab, lib, libsForQt5 }:

libsForQt5.mkDerivation rec {
  pname = "kgeotag";
  version = "1.4.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "kgeotag";
    owner = "graphics";
    rev = "v${version}";
    hash = "sha256-az/kXEhD/RGfxOMiLEcb651WVPcyBSa8B2sWOF7bz8E=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ libsForQt5.libkexiv2 libsForQt5.marble ];

  meta = with lib; {
    homepage = "https://kgeotag.kde.org/";
    description = "A stand-alone photo geotagging program";
    changelog = "https://invent.kde.org/graphics/kgeotag/-/blob/master/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cimm ];
    mainProgram = "kgeotag";
  };
}
