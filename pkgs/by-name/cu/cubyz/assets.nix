{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0-unstable-2025-09-13";
  pname = "cubyz-assets";
  src = fetchFromGitHub {
    owner = "PixelGuys";
    repo = "Cubyz-Assets";
    rev = "fc6e9a79b7806fe753799ac0ebe83735da9cd999";
    hash = "sha256-adMgfoAlyqRTIO8R42djn6FbLoDpFZDcWQdbm9f0p+A=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r $src/* $out

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/PixelGuys/Cubyz-assets";
    description = "Cache for large assets, like music, used by Cubyz";
    license = lib.licenses.gpl3Only;
    mainProgram = "cubyz";
    maintainers = with lib.maintainers; [ leha44581 ];
  };
})
