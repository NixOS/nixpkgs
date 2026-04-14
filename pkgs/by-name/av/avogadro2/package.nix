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

stdenv.mkDerivation (finalAttrs: {
  pname = "avogadro2";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadroapp";
    rev = finalAttrs.version;
    hash = "sha256-+/NZwLRrbrfrQqxLqgiqZk6324BGoN+qRfOq7G+UIBE=";
  };

  postUnpack =
    let
      avogadroI18N = fetchFromGitHub {
        owner = "OpenChemistry";
        repo = "avogadro-i18n";
        tag = finalAttrs.version;
        hash = "sha256-5eiOFJ5tbS+HFbnLbc6sjk62BvXDMQYpPsB4xFpVWXM=";
      };
    in
    ''
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
