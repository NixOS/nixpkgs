{
  lib,
  stdenv,
  fetchgit,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "fc6e9a79b7806fe753799ac0ebe83735da9cd999";
  pname = "cubyz-assets";
  src = fetchgit {
    rev = finalAttrs.version;
    url = "https://github.com/PixelGuys/Cubyz-Assets";
    hash = "sha256-adMgfoAlyqRTIO8R42djn6FbLoDpFZDcWQdbm9f0p+A=";
  };

  buildCommand = ''mkdir -p $out && cp -r $src/* $out'';

  meta = {
    homepage = "https://github.com/PixelGuys/Cubyz-assets";
    description = "The cache for large assets, like music, used by Cubyz. This is separated to reduce the size of the main repository and download times on update.";
    license = lib.licenses.gpl3Only;
    mainProgram = "cubyz";
    maintainers = with lib.maintainers; [ leha44581 ];
  };
})
