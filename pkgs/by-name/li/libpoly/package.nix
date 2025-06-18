{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  cmake,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libpoly";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "libpoly";
    # they've pushed to the release branch, use explicit tag
    tag = "v${version}";
    sha256 = "sha256-gE2O1YfiVab/aIqheoMP8GhE+N3yho7kb5EP56pzjW8=";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-warn " -Werror " " "
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    gmp
    python3
  ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://github.com/SRI-CSL/libpoly";
    description = "C library for manipulating polynomials";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
