{
  lib,
  stdenv,
  fetchFromGitHub,
  openttd-grfcodec,
  openttd-nml,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openttd-opengfx";
  version = "8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    repo = "OpenGfx";
    owner = "OpenTTD";
    tag = finalAttrs.version;
    hash = "sha256-5kM+MlI+9xXX0igK6bywU1ebINjzUpvZwMes5/LqfmY=";
  };

  postPatch = ''
    patchShebangs scripts/translations.sh
  '';

  nativeBuildInputs = [
    openttd-grfcodec
    openttd-nml
  ];

  makeFlags = [
    "INSTALL_DIR=${placeholder "out"}/opengfx-${finalAttrs.version}"
  ];

  meta = {
    changelog = "https://github.com/OpenTTD/OpenGFX/blob/master/changelog.txt";
    homepage = "https://github.com/OpenTTD/OpenGFX/";
    description = "8bpp Graphics Base Set for OpenTTD";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magicquark ];
    platforms = lib.platforms.all;
  };
})
