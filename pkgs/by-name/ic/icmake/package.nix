{
  lib,
  stdenv,
  fetchFromGitLab,
  makeWrapper,
  gcc,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icmake";
  version = "9.03.01";

  src = fetchFromGitLab {
    hash = "sha256-XqIwIqgqVuKpee9F0kQue4tbKWh9iXUlxGJDwJNRIBc=";
    rev = finalAttrs.version;
    repo = "icmake";
    owner = "fbb-git";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */icmake)
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ gcc ];

  preConfigure = ''
    patchShebangs ./
    substituteInPlace INSTALL.im --replace "usr/" ""
  '';

  buildPhase = ''
    ./icm_prepare $out
    ./icm_bootstrap x
  '';

  installPhase = ''
    ./icm_install all /

    wrapProgram $out/bin/icmbuild \
     --prefix PATH : ${ncurses}/bin
  '';

  meta = {
    description = "Program maintenance (make) utility using a C-like grammar";
    homepage = "https://fbb-git.gitlab.io/icmake/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
