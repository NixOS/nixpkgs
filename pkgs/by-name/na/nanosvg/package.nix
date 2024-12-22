{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "nanosvg";
  version = "0-unstable-2023-12-30";

  src = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "93ce879dc4c04a3ef1758428ec80083c38610b1f";
    hash = "sha256-ZtenaXJqMZr2+BxYENG1zUoQ+Qoxlxy0m/1YfJBKAFk=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Simple stupid SVG parser";
    homepage = "https://github.com/memononen/nanosvg";
    license = licenses.zlib;
    platforms = platforms.all;
  };
}
