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

stdenv.mkDerivation (finalAttrs: {
  pname = "fswatch";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = finalAttrs.version;
    sha256 = "sha256-vzTegBbAgwscFuHbMKlXOmw6PuDRGeJiUciFxF55pKE=";
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

  meta = {
    description = "Cross-platform file change monitor with multiple backends";
    mainProgram = "fswatch";
    homepage = "https://github.com/emcrisostomo/fswatch";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
