{
  lib,
  stdenv,
  dos2unix,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bwbasic";
  version = "3.40";

  src = fetchurl {
    url = "mirror://sourceforge/project/bwbasic/bwbasic/version%20${finalAttrs.version}/bwbasic-${finalAttrs.version}.zip";
    hash = "sha256-tWiUIqCdBarhFDSX0iV55VxOEh7iuAbnOLSDuMAAog8=";
  };

  nativeBuildInputs = [
    dos2unix
    unzip
  ];

  sourceRoot = ".";

  postPatch = ''
    dos2unix configure
    patchShebangs configure
    chmod +x configure
    substituteInPlace bwbasic.h \
      --replace-fail "extern int putenv (const char *buffer)" "extern int putenv (char *buffer)"
  '';

  env.NIX_CFLAGS_COMPILE = "-std=c89";

  hardeningDisable = [ "format" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "Bywater BASIC Interpreter";
    mainProgram = "bwbasic";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ irenes ];
    platforms = lib.platforms.all;
    homepage = "https://sourceforge.net/projects/bwbasic/";
  };
})
