{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  unixtools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "microscheme";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "ryansuchocki";
    repo = "microscheme";
    rev = "v${finalAttrs.version}";
    sha256 = "5qTWsBCfj5DCZ3f9W1bdo6WAc1DZqVxg8D7pwC95duQ=";
  };

  postPatch = ''
    substituteInPlace makefile --replace gcc ${stdenv.cc.targetPrefix}cc
  '';

  nativeBuildInputs = [
    makeWrapper
    unixtools.xxd
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

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
