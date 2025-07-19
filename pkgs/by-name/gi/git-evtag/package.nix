{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libxslt,
  docbook-xsl-nons,
  glib,
  libgit2,
}:

stdenv.mkDerivation rec {
  pname = "git-evtag";
  version = "2022.1";

  src = fetchFromGitHub {
    owner = "cgwalters";
    repo = "git-evtag";
    rev = "v${version}";
    hash = "sha256-+nGPfISDpf2YMeCtPgaOOwzYijTPGRVCzT+74sGZ3JY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    # Man page
    libxslt
    docbook-xsl-nons
  ];

  buildInputs = [
    glib
    libgit2
  ];

  meta = {
    description = "Extended verification for git tags";
    homepage = "https://github.com/cgwalters/git-evtag";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    mainProgram = "git-evtag";
    platforms = lib.platforms.unix;
  };
}
