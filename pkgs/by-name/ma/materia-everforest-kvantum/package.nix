{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "materia-everforest-kvantum";
  version = "0-unstable-2024-01-22";

  src = fetchFromGitHub {
    owner = "binEpilo";
    repo = "materia-everforest-kvantum";
    rev = "391eb1d917dab900dc1ef16ffdff1a4546308ee4";
    hash = "sha256-5ihKScPJMDU0pbeYtUx/UjC4J08/r40mAK7D+1TK6wA=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/Kvantum
    cp -a MateriaEverforestDark $out/share/Kvantum

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Everforest theme for Kvantum";
    homepage = "https://github.com/binEpilo/materia-everforest-kvantum";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.poz ];
  };
}
