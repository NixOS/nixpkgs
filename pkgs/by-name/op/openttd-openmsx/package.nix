{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openttd-openmsx";
  version = "0.4.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "OpenMSX";
    tag = finalAttrs.version;
    hash = "sha256-l5yD2+iTk/3xa5wBpg6SOY5sMUYpUnUtEaIOrKJqQio=";
  };

  postPatch = ''
    patchShebangs scripts/*
    substituteInPlace scripts/md5list.py \
      --replace-fail "md5call = [\"md5\", \"-r\"]" "md5call = [\"md5sum\"]"
  '';

  makeFlags = [
    "INSTALL_DIR=${placeholder "out"}"
    "DIR_NAME=openmsx-${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    python3
  ];

  meta = {
    changelog = "https://github.com/OpenTTD/OpenMSX/blob/master/changelog.txt";
    homepage = "https://github.com/OpenTTD/OpenMSX";
    description = "Music Base Set for OpenTTD";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magicquark ];
    platforms = lib.platforms.all;
  };
})
