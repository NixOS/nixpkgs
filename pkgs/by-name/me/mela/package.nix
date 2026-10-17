{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mela";
  version = "2.0.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vbertone";
    repo = "MELA";
    tag = finalAttrs.version;
    hash = "sha256-PjFblE0vt5LRyHovMgjqc+KpG7nw5lVSR8WSzitpTwc=";
  };

  nativeBuildInputs = [ gfortran ];

  enableParallelBuilding = true;

  meta = {
    description = "Mellin Evolution LibrAry";
    mainProgram = "mela-config";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/vbertone/MELA";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
