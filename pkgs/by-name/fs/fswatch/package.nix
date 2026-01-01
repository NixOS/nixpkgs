{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  # for xargs
  gettext,
  libtool,
  makeWrapper,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "fswatch";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "sha256-C/NHDhhRTQppu8xRWe9fy1+KIutyoRbkkabUtGlJ1fE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];
  buildInputs = [
    gettext
    libtool
    texinfo
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "Cross-platform file change monitor with multiple backends";
    mainProgram = "fswatch";
    homepage = "https://github.com/emcrisostomo/fswatch";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
=======
  meta = with lib; {
    description = "Cross-platform file change monitor with multiple backends";
    mainProgram = "fswatch";
    homepage = "https://github.com/emcrisostomo/fswatch";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
