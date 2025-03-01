{
  lib,
  stdenv,
  pkg-config,
  autoreconfHook,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "libspiro";
  version = "20240903";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = pname;
    rev = version;
    sha256 = "sha256-psEF1SWkire6ngEUcMU0xnGYaT8ktqDCBlBckToGUMg=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = with lib; {
    description = "Library that simplifies the drawing of beautiful curves";
    homepage = "https://github.com/fontforge/libspiro";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.erictapen ];
  };
}
