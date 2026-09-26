{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  unixtools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "microscheme";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "ryansuchocki";
    repo = "microscheme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/LUiPZRV1AuCvKS1+0S0JCHauZMPGr2eXag0dnPk1K0=";
  };

  postPatch = ''
    substituteInPlace makefile \
      --replace-fail gcc ${stdenv.cc.targetPrefix}cc \
      --replace-fail " -Werror" ""
  '';

  nativeBuildInputs = [
    makeWrapper
    unixtools.xxd
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildFlags = [ "build" ];

  meta = {
    homepage = "https://ryansuchocki.github.io/microscheme/";
    description = "Scheme subset for Atmel microcontrollers";
    mainProgram = "microscheme";
    longDescription = ''
      Microscheme is a Scheme subset/variant designed for Atmel
      microcontrollers, especially as found on Arduino boards.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ardumont ];
  };
})
