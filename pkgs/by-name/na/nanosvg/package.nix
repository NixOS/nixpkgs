{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "nanosvg";
  version = "0-unstable-2026-05-18";

  src = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "48120e91e64b2f409ed600cdfd6d790a49ba11ab";
    hash = "sha256-onjmiWQPftr4AWySwJOpMLZ3WQGvUp9wj9isdUyNIPc=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Simple stupid SVG parser";
    homepage = "https://github.com/memononen/nanosvg";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
    hasNoMaintainersButDependents = true;
  };
}
