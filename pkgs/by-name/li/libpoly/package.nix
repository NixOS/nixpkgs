{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpoly";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "libpoly";
    # they've pushed to the release branch, use explicit tag
    tag = "v${finalAttrs.version}";
    hash =
      {
        "0.2.1" = "sha256-uDWDio+RzJrgGKbWfT6S6voaJrJR0PzPfyr+33dr0ds=";
        "0.2.0" = "sha256-gE2O1YfiVab/aIqheoMP8GhE+N3yho7kb5EP56pzjW8=";
      }
      ."${finalAttrs.version}";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-warn " -Werror " " "
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    gmp
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/SRI-CSL/libpoly";
    description = "C library for manipulating polynomials";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.all;
  };
})
