{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  darwin,
  nim,
  git,
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "taskopen";

  version = "v2.0.1";

  src = fetchFromGitHub {
    owner = "jschlatow";
    repo = "taskopen";
    rev = "refs/tags/${version}";
    hash = "sha256-Gy0QS+FCpg5NGSctVspw+tNiBnBufw28PLqKxnaEV7I=";
  };

  sourceRoot = "${finalAttrs.src.name}/";

  postPatch = ''
    # We don't need a DESTDIR and an empty string results in an absolute path
    # (due to the trailing slash) which breaks the build.
    sed 's|$(DESTDIR)/||' -i Makefile
  '';

  nativeBuildInputs = [makeWrapper];
  buildInputs = [nim git];

  buildPhase = ''
    export HOME=$(pwd)
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with lib; {
    description = "Script for taking notes and open urls with taskwarrior";
    mainProgram = "taskopen";
    homepage = "https://github.com/jschlatow/taskopen";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2Plus;
    maintainers = [maintainers.winpat];
  };
})
