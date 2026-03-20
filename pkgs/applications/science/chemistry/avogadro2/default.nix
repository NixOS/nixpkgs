{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  avogadrolibs,
  hdf5,
  jkqtplotter,
  openbabel,
  qt6,
  mesa,
}:

let
  avogadroI18N = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadro-i18n";
    tag = "1.103.0";
    hash = "sha256-gdr0Ed0UWjQB0LQq+6RvlAb8ZNFQAjV9mrgFLePG+CM=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "avogadro2";
  version = "1.103.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadroapp";
    rev = finalAttrs.version;
    hash = "sha256-nmvK3R966Xv2Xs5wXDh/8itIZLIRqbXHFe8dffFiI+s=";
  };

  postUnpack = ''
    cp -r ${avogadroI18N} avogadro-i18n
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    avogadrolibs
    eigen
    hdf5
    jkqtplotter
    qt6.qttools
  ];

  propagatedBuildInputs = [ openbabel ];

  qtWrapperArgs = [ "--prefix PATH : ${lib.getBin openbabel}/bin" ];

  meta = {
    description = "Molecule editor and visualizer";
    mainProgram = "avogadro2";
    maintainers = with lib.maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/avogadroapp";
    inherit (mesa.meta) platforms;
    license = lib.licenses.bsd3;
  };
})
