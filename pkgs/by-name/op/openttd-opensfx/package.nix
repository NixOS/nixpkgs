{
  lib,
  stdenv,
  fetchFromGitHub,
  openttd-catcodec,
  python3,
  which,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openttd-opensfx";
  version = "1.0.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "OpenSFX";
    tag = finalAttrs.version;
    hash = "sha256-VXxu6LD+TThHMY4PWjDtXTpochiMIch9Ru6G621P60o=";
  };

  postPatch = ''
    patchShebangs scripts/translations.sh
  '';

  nativeBuildInputs = [
    openttd-catcodec
    python3
    which
  ];

  makeFlags = [
    "INSTALL_DIR=${placeholder "out"}"
    "DIR_NAME=opensfx-${finalAttrs.version}"
  ];

  meta = {
    changelog = "https://github.com/OpenTTD/OpenSFX/blob/master/changelog.txt";
    homepage = "https://github.com/OpenTTD/OpenSFX/";
    description = "Sound Base Set for OpenTTD";
    license = lib.licenses.cc-by-sa-30;
    maintainers = [ lib.maintainers.magicquark ];
    platforms = lib.platforms.all;
  };
})
