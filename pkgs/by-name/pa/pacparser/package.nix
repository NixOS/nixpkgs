{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pacparser";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "manugarg";
    repo = "pacparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CkaRgm5xZHKiewPDSp0bzVkgAOeTbuGrY3FM4HaN97I=";
  };

  makeFlags = [
    "NO_INTERNET=1"
    "PREFIX=${placeholder "out"}"
    "VERSION=v${finalAttrs.version}"
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs tests/runtests.sh
    cd src
  '';

  hardeningDisable = [ "format" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  meta = {
    description = "Library to parse proxy auto-config (PAC) files";
    homepage = "https://pacparser.manugarg.com/";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "pactester";
  };
})
