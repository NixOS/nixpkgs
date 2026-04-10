{
  lib,
  stdenv,
  pkg-config,
  autoreconfHook,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspiro";
  version = "20240903";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "libspiro";
    rev = finalAttrs.version;
    sha256 = "sha256-psEF1SWkire6ngEUcMU0xnGYaT8ktqDCBlBckToGUMg=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = {
    description = "Library that simplifies the drawing of beautiful curves";
    homepage = "https://github.com/fontforge/libspiro";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.erictapen ];
  };
})
