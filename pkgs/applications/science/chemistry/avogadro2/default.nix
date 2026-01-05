{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  avogadrolibs,
  molequeue,
  hdf5,
  jkqtplotter,
  openbabel,
  qttools,
  wrapQtAppsHook,
  mesa,
}:

let
  avogadroI18N = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadro-i18n";
    tag = "1.102.1";
    hash = "sha256-doY+AWJ0GiE6VsTolgmFIRcRVl52lTgwNJLpXgVQ57c=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "avogadro2";
  version = "1.102.1";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadroapp";
    rev = finalAttrs.version;
    hash = "sha256-nBkOiw6JO/cG1Ob9gw7Tt/076OoRaRRmDc/a9YAfZCA=";
  };

  postUnpack = ''
    cp -r ${avogadroI18N} avogadro-i18n
  '';

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    avogadrolibs
    molequeue
    eigen
    hdf5
    jkqtplotter
    qttools
  ];

  propagatedBuildInputs = [ openbabel ];

  qtWrapperArgs = [ "--prefix PATH : ${lib.getBin openbabel}/bin" ];

  meta = with lib; {
    description = "Molecule editor and visualizer";
    mainProgram = "avogadro2";
    maintainers = with maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/avogadroapp";
    inherit (mesa.meta) platforms;
    license = licenses.bsd3;
  };
})
