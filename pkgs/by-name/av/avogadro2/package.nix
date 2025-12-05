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
  qt5,
  mesa,
  nix-update-script,
}:

let
  version = "1.102.1";

  avogadroI18N = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadro-i18n";
    tag = version;
    hash = "sha256-doY+AWJ0GiE6VsTolgmFIRcRVl52lTgwNJLpXgVQ57c=";
  };

in
stdenv.mkDerivation {
  inherit version;
  pname = "avogadro2";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadroapp";
    tag = version;
    hash = "sha256-nBkOiw6JO/cG1Ob9gw7Tt/076OoRaRRmDc/a9YAfZCA=";
  };

  postUnpack = ''
    cp -r ${avogadroI18N} avogadro-i18n
  '';

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    avogadrolibs
    molequeue
    eigen
    hdf5
    jkqtplotter
    qt5.qttools
  ];

  propagatedBuildInputs = [ openbabel ];

  qtWrapperArgs = [ "--prefix PATH : ${lib.getBin openbabel}/bin" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Molecule editor and visualizer";
    mainProgram = "avogadro2";
    maintainers = with lib.maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/avogadroapp";
    inherit (mesa.meta) platforms;
    license = lib.licenses.bsd3;
  };
}
