{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openttd-catcodec";
  version = "1.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "catcodec";
    tag = finalAttrs.version;
    hash = "sha256-/5P7IAiEgN4axhiFDTQZDgh0avX/zivLDgxFJ7g1yjM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    changelog = "https://github.com/OpenTTD/catcodec/blob/master/changelog.md";
    homepage = "https://github.com/OpenTTD/catcodec";
    description = "Encoder/decoder for OpenTTD Sound Base Sets";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magicquark ];
    platforms = lib.platforms.all;
  };
})
