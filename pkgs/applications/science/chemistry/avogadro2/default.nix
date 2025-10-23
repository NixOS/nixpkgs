{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  avogadrolibs,
  molequeue,
  hdf5,
  openbabel,
  qttools,
  wrapQtAppsHook,
  mesa,
}:

let
  avogadroI18N = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadro-i18n";
    tag = "1.101.0";
    hash = "sha256-3qFx/rc5xqfrLq3Kr5b/Rid2LR/gfP6uqhhATyQL6Y8=";
  };

in
stdenv.mkDerivation rec {
  pname = "avogadro2";
  version = "1.101.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadroapp";
    rev = version;
    hash = "sha256-F8to1DyeyyhsivkXDB/KH10/7teVnsoSU/ZHIsNISqc=";
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
}
